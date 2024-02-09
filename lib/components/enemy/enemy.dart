import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:mario_flutter/components/collision_block/collision_block.dart';
import 'package:mario_flutter/components/enemy/enemy_common.dart';
import 'package:mario_flutter/global_constants.dart';
import 'package:mario_flutter/mario_run.dart';
import 'package:mario_flutter/utils.dart';

enum EnemyState { walking, dead }

class Enemy extends SpriteAnimationGroupComponent
    with HasGameRef<MarioRun>, CollisionCallbacks {
  final EnemyType enemyType;
  late final SpriteAnimation walkingAnimation;
  late final SpriteAnimation deadAnimation;
  EnemyCommonData? selectedEnemyData;

  final hitBox = CommonHitbox(offsetX: 10, offsetY: 0, width: 30, height: 70);

  static const Map<EnemyType, EnemyCommonData> _enemyDetails = {
    EnemyType.goomba: EnemyCommonData(
      width: 60,
      height: 70,
      offsetX: 0,
      offsetY: 0,
      stepTime: 0.2,
      imagePath: 'characters/goomba.png',
      nRows: 1,
      nColumns: 3,
      walkFrom: 0,
      walkTo: 2,
      deadFrom: 2,
      deadTo: 3,
      hitBoxHeight: 60,
      hitBoxOffsetY: 5,
      hitBoxWidth: 35,
      moveSpeed: 100,
    ),
    EnemyType.greenDuck: EnemyCommonData(
        width: 80,
        height: 70,
        offsetX: 10,
        offsetY: 0,
        stepTime: 0.2,
        imagePath: 'characters/duck_green.png',
        nRows: 1,
        nColumns: 10,
        walkFrom: 2,
        walkTo: 4,
        deadFrom: 8,
        deadTo: 10,
        hitBoxHeight: 60,
        hitBoxWidth: 50,
        hitBoxOffsetX: 12,
        hitBoxOffsetY: 5,
        moveSpeed: 125),
    EnemyType.redDuck: EnemyCommonData(
        width: 80,
        height: 70,
        offsetX: 10,
        offsetY: 0,
        stepTime: 0.2,
        imagePath: 'characters/red_duck.png',
        nRows: 1,
        nColumns: 10,
        walkFrom: 2,
        walkTo: 4,
        deadFrom: 8,
        deadTo: 10,
        hitBoxHeight: 60,
        hitBoxWidth: 50,
        hitBoxOffsetX: 12,
        hitBoxOffsetY: 5,
        moveSpeed: 150),
    EnemyType.browser: EnemyCommonData(
        width: 80,
        height: 100,
        offsetX: 10,
        offsetY: 0,
        stepTime: 0.2,
        imagePath: 'characters/browser.png',
        nRows: 1,
        willDie: false,
        nColumns: 4,
        walkFrom: 0,
        walkTo: 4,
        deadFrom: 0,
        deadTo: 4,
        hitBoxHeight: 100,
        hitBoxWidth: 60,
        moveSpeed: 250),
    EnemyType.flame: EnemyCommonData(
        width: 70,
        height: 40,
        offsetX: 10,
        offsetY: 0,
        stepTime: 0.2,
        imagePath: 'characters/flame.png',
        nRows: 1,
        nColumns: 2,
        walkFrom: 0,
        walkTo: 2,
        deadFrom: 0,
        deadTo: 2,
        hitBoxHeight: 20,
        hitBoxWidth: 50,
        moveSpeed: 200,
        willDie: false,
        isFlying: true),
  };

  Enemy({required this.enemyType});

  @override
  FutureOr<void> onLoad() {
    selectedEnemyData = _enemyDetails[enemyType]!;
    priority = -1;
    add(
      RectangleHitbox(
        position: Vector2(
            selectedEnemyData!.hitBoxOffsetX, selectedEnemyData!.hitBoxOffsetY),
        size: Vector2(
            selectedEnemyData!.hitBoxWidth, selectedEnemyData!.hitBoxHeight),
        collisionType: CollisionType.passive,
      ),
    );
    debugMode = false;
    _loadAnimation(selectedEnemyData!);
    addCollision();
    return super.onLoad();
  }

  void _loadAnimation(EnemyCommonData enemyData) {
    walkingAnimation = _createSpriteAnimation(
        to: enemyData.walkTo, from: enemyData.walkFrom, enemyData: enemyData);
    deadAnimation = _createSpriteAnimation(
        to: enemyData.deadTo, from: enemyData.deadFrom, enemyData: enemyData);

    animations = {
      EnemyState.walking: walkingAnimation,
      EnemyState.dead: deadAnimation,
    };

    width = enemyData.width;
    height = enemyData.height;
    x = game.size.x;
    y = enemyData.isFlying
        ? (game.size.y - height - 50)
        : (game.size.y - height - 16);

    current = EnemyState.walking;
  }

  SpriteAnimation _createSpriteAnimation(
      {required to, required from, required EnemyCommonData enemyData}) {
    final image = game.images.fromCache(enemyData.imagePath);
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: image, rows: enemyData.nRows, columns: enemyData.nColumns);
    return spriteSheet.createAnimation(
        row: 0, stepTime: commonStepTime, from: from, to: to, loop: true);
  }

  @override
  void update(double dt) {
    super.update(dt);

    x -= selectedEnemyData!.moveSpeed * 1.3 * dt;
  }

  void addCollision() {
    final collisionBlock = CollisionBlock(
        position: Vector2(x, y), size: Vector2(width, height), isEnemy: true);
    add(collisionBlock);
    game.mario.collisionBlocks.add(collisionBlock);
  }

  void removeEnemy(Enemy enemy) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    enemy.removeFromParent();
  }

  bool destroy() {
    return x < (width);
  }
}
