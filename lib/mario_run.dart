import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:mario_flutter/components/background/parallax_bg.dart';
import 'package:mario_flutter/components/enemy/enemy_manager.dart';
import 'package:mario_flutter/components/player/mario.dart';

class MarioRun extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  final Mario mario = Mario();

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final parallaxComponent = ParallaxBg(
      mario: mario,
    );

    final EnemyManager enemyManager = EnemyManager();

    addAll([parallaxComponent, enemyManager]);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
