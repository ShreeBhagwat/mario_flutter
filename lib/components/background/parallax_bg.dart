import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:mario_flutter/components/collision_block/collision_block.dart';
import 'package:mario_flutter/components/items/icons.dart';
import 'package:mario_flutter/components/player/mario.dart';
import 'package:mario_flutter/mario_run.dart';

class ParallaxBg extends Component
    with HasGameRef<MarioRun>, CollisionCallbacks {
  final Mario mario;
  final IconsPoints iconPoints;
  TextComponent? scoreTextComponent;
  SpriteButtonComponent? pauseButton;

  ParallaxComponent? parallaxComponent;
  List<CollisionBlock> collisionBlocks = [];
  double baseVelocity = 0;
  ParallaxBg({
    super.children,
    super.priority,
    super.key,
    required this.mario,
    required this.iconPoints,
  });

  @override
  Future<void> onLoad() async {
    priority = -2;
    final parallax = await _loadParallaxBackground();
    _addCollisionPlatform();

    scoreTextComponent = TextComponent(
      position: Vector2(game.size.x - 20, 30),
      text: game.score.toString(),
      textRenderer: TextPaint(
        style: const TextStyle(
            color: Colors.white, fontSize: 30, fontFamily: 'super_mario'),
      ),
    );
    scoreTextComponent!.anchor = Anchor.topRight;
    initPauseButton();

    addAll([
      parallax, mario,
       scoreTextComponent!, pauseButton!, iconPoints
    ]);

    return super.onLoad();
  }

  void initPauseButton() {
    pauseButton = SpriteButtonComponent(
      button: game.isPaused
          ? Sprite(game.images.fromCache('items/play.png'))
          : Sprite(game.images.fromCache('items/pause.png')),
      position: Vector2(0, 50),
      size: Vector2(50, 50),
      onPressed: () {
        if (!game.playSounds) {
          FlameAudio.play('pause.wav', volume: game.soundVolume);
        }
        if (game.isPaused) {
          game.isPaused = false;
          game.resumeEngine();
        } else {
          game.isPaused = true;
          game.pauseEngine();
        }
        // game.overlays.add('MainMenu');
      },
    );
    pauseButton!.anchor = Anchor.topLeft;
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

  @override
  void update(double dt) {
    game.score += 1.toInt();
    scoreTextComponent!.text = game.score.toString();
    super.update(dt);
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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }
}
