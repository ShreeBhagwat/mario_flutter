import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';
import 'package:mario_flutter/components/collision_block/collision_block.dart';
import 'package:mario_flutter/mario_run.dart';

enum IconState {
  icon,
  disapear,
}

class IconsPoints extends SpriteAnimationGroupComponent
    with HasGameRef<MarioRun>, CollisionCallbacks {
  late final SpriteAnimation iconAnimation;
  late final SpriteAnimation disapearAnimation;
  late Timer timer;

  final double stepTime = 0.2;
  bool isCollided = false;
  int moveSpeed = 100;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = 2;
    loadAnimation();
    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(30, 50),
    ));
    addCollision();
    width = 40;
    height = 60;
    x = game.size.x - 100;
    y = game.size.y - 100;

    return super.onLoad();
  }

  //   @override
  // void onMount() {
  //   super.onMount();
  //   timer.start();
  // }

  @override
  void update(double dt) {
    x -= moveSpeed * 1.3 * dt;
    super.update(dt);
  }

  void loadAnimation() {
    iconAnimation = _createSpriteAnimation(to: 4, from: 0);
    disapearAnimation = _createSpriteDisapearingAnimation(to: 7, from: 0);

    animations = {
      IconState.icon: iconAnimation,
      IconState.disapear: disapearAnimation,
    };
    current = IconState.icon;
  }

  void addCollision() {
    final collisionBlock = CollisionBlock(
        position: Vector2(0, 0), size: Vector2(30, 50), isCoin: true);
    add(collisionBlock);
    game.mario.collisionBlocks.add(collisionBlock);
  }

  SpriteAnimation _createSpriteAnimation({required to, required from}) {
    final image = game.images.fromCache('items/coins.png');
    final spriteSheet =
        SpriteSheet.fromColumnsAndRows(image: image, rows: 1, columns: 4);
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

  void removeIcon() {
    game.score += 10;
    current = IconState.disapear;
    Future.delayed(const Duration(milliseconds: 200), () {
      removeFromParent();
    });
  }
}
