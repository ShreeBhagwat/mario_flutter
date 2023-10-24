import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:mario_flutter/components/collision_block/collision_block.dart';
import 'package:mario_flutter/components/enemy/enemy.dart';
import 'package:mario_flutter/components/items/icons.dart';
import 'package:mario_flutter/mario_run.dart';
import 'package:mario_flutter/utils.dart';

enum MarioState {
  idle,
  running,
  jumping,
  falling,
  ducking,
  dead,
  disapear,
}

class Mario extends SpriteAnimationGroupComponent
    with HasGameRef<MarioRun>, CollisionCallbacks, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation deadAnimation;
  late final SpriteAnimation duckingAnimation;
  late final SpriteAnimation disapearAnimation;
  final double stepTime = 0.2;

  final double _gravity = 9.8;
  final double _jumpForce = 350;
  final double terminalVelocity = 630;
  int horizontalMovement = 0;
  final double moveSpeed = 200;
  static const bounceHeight = 300.0;

  bool gothitByEnemy = false;
  bool isOnGround = false;
  bool hasJumped = false;
  bool isMoving = false;
  bool isDucking = false;
  bool isBounce = false;

  List<CollisionBlock> collisionBlocks = [];

  Vector2 velocity = Vector2.zero();

  CommonHitbox playerHitbox = CommonHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 40,
    height: 70,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    add(RectangleHitbox(
      position: Vector2(playerHitbox.offsetX, playerHitbox.offsetY),
      size: Vector2(playerHitbox.width, playerHitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(dt) {
    if (!gothitByEnemy) {
      _updateMarioState();
      _updatePlayerMovement(dt);
      _applyVerticalCollision();
      _applyGravity(dt);
    }

    if (current == MarioState.disapear) {
      game.pauseEngine();
      game.overlays.add('GameOverMenu');
    }

    super.update(dt);
  }

  _loadAllAnimation() {
    idleAnimation = _createSpriteAnimation(from: 0, to: 1);
    runningAnimation = _createSpriteAnimation(from: 1, to: 3);
    jumpingAnimation = _createSpriteAnimation(from: 5, to: 6);
    duckingAnimation = _createSpriteAnimation(from: 6, to: 7);
    deadAnimation = _createSpriteDeadAnimation(from: 0, to: 1);
    disapearAnimation = _createSpriteDisapearingAnimation(from: 0, to: 7);

    animations = {
      MarioState.idle: idleAnimation,
      MarioState.running: runningAnimation,
      MarioState.jumping: jumpingAnimation,
      MarioState.falling: idleAnimation,
      MarioState.dead: deadAnimation,
      MarioState.ducking: duckingAnimation,
      MarioState.disapear: disapearAnimation,
    };

    width = 70;
    height = 70;
    x = 100;
    y = 100;

    current = MarioState.running;
  }

  SpriteAnimation _createSpriteAnimation({required to, required from}) {
    final image = game.images.fromCache('characters/mario.png');
    final spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, rows: 1, columns: 7);
    return spriteSheet.createAnimation(
        row: 0, stepTime: stepTime, from: from, to: to, loop: true);
  }

  SpriteAnimation _createSpriteDeadAnimation({required to, required from}) {
    final image = game.images.fromCache('characters/mario_dead.png');
    final spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, rows: 1, columns: 1);
    return spriteSheet.createAnimation(
        row: 0, stepTime: stepTime, from: from, to: to, loop: true);
  }

  SpriteAnimation _createSpriteDisapearingAnimation(
      {required to, required from}) {
    final image = game.images.fromCache('characters/disapearing.png');
    final spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, rows: 1, columns: 7);
    return spriteSheet.createAnimation(
        row: 0, stepTime: stepTime, from: from, to: to, loop: true);
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, terminalVelocity);

    position.y += velocity.y * dt;
  }

  void _applyVerticalCollision() {
    for (final bloc in collisionBlocks) {
      if (bloc.isPlatform) {
        if (checkCollision(this, bloc)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = bloc.position.y - height;
            isOnGround = true;
            current = MarioState.running;
          }
        }
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      if (isOnGround && other.current == EnemyState.walking) {
        gothitByEnemy = true;

        current = MarioState.dead;
        current = MarioState.disapear;
        if (game.playSounds) {
          FlameAudio.play('mariodie.wav', volume: game.soundVolume);
        }
        Future.delayed(const Duration(milliseconds: 400), () {
          removeFromParent();
        });
      } else if (other.current == EnemyState.walking &&
          !isOnGround &&
          other.selectedEnemyData!.willDie) {
        velocity.y = -bounceHeight;
        if (game.playSounds) {
          FlameAudio.play('enemy_death.wav', volume: game.soundVolume);
        }
        other.current = EnemyState.dead;
        other.removeEnemy(other);
      }
    } else if (other is IconsPoints) {
      if (game.playSounds) {
        FlameAudio.play('coin_collect.wav', volume: game.soundVolume);
      }
      other.removeIcon();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isJumpKeyPressed = keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    final isBothKeyPressed = isLeftKeyPressed && isRightKeyPressed;

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    if (isBothKeyPressed) horizontalMovement = 0;

    final isDuckingKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
            keysPressed.contains(LogicalKeyboardKey.keyS);
    hasJumped = isJumpKeyPressed;
    isDucking = isDuckingKeyPressed;

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _marioJumped(dt);
    if (velocity.y > _gravity) isOnGround = false;
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
    horizontalMovement != 0 ? isMoving = true : isMoving = false;
  }

  void _marioJumped(double dt) {
    if (game.playSounds) {
      FlameAudio.play('jump.wav', volume: game.soundVolume);
    }
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasJumped = false;
    isOnGround = false;
  }

  void _updateMarioState() {
    MarioState marioState = MarioState.idle;

    if (velocity.y < 0) marioState = MarioState.jumping;

    if (velocity.y > 0) marioState = MarioState.jumping;
    if (isDucking && isOnGround) marioState = MarioState.ducking;

    current = marioState;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }
}
