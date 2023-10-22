import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:mario_flutter/components/collision_block/collision_block.dart';
import 'package:mario_flutter/components/player/mario.dart';
import 'package:mario_flutter/mario_run.dart';

class ParallaxBg extends Component
    with HasGameRef<MarioRun>, CollisionCallbacks {
  final Mario mario;
  // final List enemies;

  ParallaxComponent? parallaxComponent;
  List<CollisionBlock> collisionBlocks = [];
  double baseVelocity = 0;
  ParallaxBg({
    super.children,
    super.priority,
    super.key,
    required this.mario,
    // required this.enemies
  });

  @override
  Future<void> onLoad() async {
    priority = -2;
    // debugMode = true;
    final parallax = await _loadParallaxBackground();
    _addCollisionPlatform();

    addAll([parallax, mario]);
    return super.onLoad();
  }

  Future<ParallaxComponent> _loadParallaxBackground() async {
    final imagesList = [
      game.loadParallaxImage('parallax/pbg_0.png',
          repeat: ImageRepeat.repeatX, fill: LayerFill.height),
      game.loadParallaxImage('parallax/pbg_1.png',
          repeat: ImageRepeat.repeatX, fill: LayerFill.height),
      game.loadParallaxImage('parallax/pbg_2.png',
          repeat: ImageRepeat.repeatX, fill: LayerFill.height),
      game.loadParallaxImage('parallax/pbg_3.png',
          repeat: ImageRepeat.repeatX, fill: LayerFill.height),
      game.loadParallaxImage('parallax/pbg_4.png',
          repeat: ImageRepeat.repeatX, fill: LayerFill.height),
      game.loadParallaxImage('parallax/pbg_6.png',
          repeat: ImageRepeat.repeatX,
          fill: LayerFill.none,
          alignment: Alignment.bottomCenter),
    ];
    final layers = imagesList.map((image) async => ParallaxLayer(await image,
        velocityMultiplier: Vector2(imagesList.indexOf(image) * 0.5, 0)));

    parallaxComponent = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(50, 0),
      ),
    )..positionType = PositionType.viewport;

    return parallaxComponent!;
  }

  void _addCollisionPlatform() {
    final imageLayer = parallaxComponent!.parallax!.layers.last;

    final collisionBlock = CollisionBlock(
      position:
          Vector2(0, game.size.y - imageLayer.parallaxRenderer.image.size.y),
      size: Vector2(game.size.x, imageLayer.parallaxRenderer.image.size.y),
      isPlatform: true,
    );
    collisionBlocks.add(collisionBlock);
    add(collisionBlock);
    mario.collisionBlocks.add(collisionBlock);
  }

  @override
  void update(double dt) {
    // mario.isMoving ? baseVelocity = mario.moveSpeed: baseVelocity = 10;
    // parallaxComponent!.parallax!.baseVelocity.setFrom(Vector2(baseVelocity, 0));

    super.update(dt);
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if (other is Mario) {
  //     mario.x = game.size.x - mario.width;
  //   }
  //   super.onCollision(intersectionPoints, other);
  // }
}
