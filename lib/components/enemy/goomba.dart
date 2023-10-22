// import 'dart:async';

// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/sprite.dart';
// import 'package:mario_flutter/components/collision_block/collision_block.dart';
// import 'package:mario_flutter/global_constants.dart';
// import 'package:mario_flutter/mario_run.dart';
// import 'package:mario_flutter/utils.dart';

// enum GoombaState { walking, dead }

// class Goomba extends SpriteAnimationGroupComponent
//     with HasGameRef<MarioRun>, CollisionCallbacks {
//   late final SpriteAnimation walkingAnimation;
//   late final SpriteAnimation deadAnimation;
//   final hitBox = CommonHitbox(offsetX: 10, offsetY: 0, width: 45, height: 70);

//   @override
//   FutureOr<void> onLoad() {
//     priority = -1;
//     add(
//       RectangleHitbox(
//         position: Vector2(hitBox.offsetX, hitBox.offsetY),
//         size: Vector2(hitBox.width, hitBox.height),
//         collisionType: CollisionType.passive,
//       ),
//     );
//     debugMode = true;
//     _loadAnimation();
//     addCollision();

//     return super.onLoad();
//   }

//   void _loadAnimation() {
//     walkingAnimation = _createSpriteAnimation(to: 4, from: 2);
//     deadAnimation = _createSpriteAnimation(to: 10, from: 8);

//     animations = {
//       GoombaState.walking: walkingAnimation,
//       GoombaState.dead: deadAnimation,
//     };

//     width = 70;
//     height = 70;
//     x = game.size.x;
//     y = game.size.y - height - 18;

//     current = GoombaState.walking;
//   }

//   SpriteAnimation _createSpriteAnimation({required to, required from}) {
//     final image = game.images.fromCache('characters/duck_green.png');
//     final spriteSheet =
//         SpriteSheet.fromColumnsAndRows(image: image, rows: 1, columns: 10);
//     return spriteSheet.createAnimation(
//         row: 0, stepTime: commonStepTime, from: from, to: to, loop: true);
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);

//     x -= 100 * dt;
//   }

//   void addCollision() {
//     final collisionBlock = CollisionBlock(
//         position: Vector2(x, y), size: Vector2(width, height), isEnemy: true);
//     add(collisionBlock);
//     game.mario.collisionBlocks.add(collisionBlock);
//   }
// }
