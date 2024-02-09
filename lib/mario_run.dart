import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:mario_flutter/components/background/parallax_bg.dart';
import 'package:mario_flutter/components/enemy/enemy_manager.dart';
import 'package:mario_flutter/components/items/icons.dart';
import 'package:mario_flutter/components/player/mario.dart';

class MarioRun extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  final Mario mario = Mario();
  final IconsPoints icons = IconsPoints();

  bool playSounds = true;
  double soundVolume = 1.0;
  int score = 000;
  int coin = 00;
  bool isPaused = false;

  @override
  FutureOr<void> onLoad() async {
    FlameAudio.bgm.initialize();
    pauseEngine();
    await images.loadAllImages();

    final parallaxComponent = ParallaxBg(
      mario: mario,
      iconPoints: icons,
    );

    final EnemyManager enemyManager = EnemyManager();

    addAll([parallaxComponent, enemyManager]);
    return super.onLoad();
  }
}
