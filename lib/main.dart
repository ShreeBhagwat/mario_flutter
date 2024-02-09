import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mario_flutter/mario_run.dart';
import 'package:mario_flutter/overlays/game_over_menu.dart';
import 'package:mario_flutter/overlays/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();

  final game = MarioRun();
  runApp(GameWidget(
    game: kDebugMode ? MarioRun() : game,
    initialActiveOverlays: ['MainMenu'],
    overlayBuilderMap: {
      'MainMenu': (_, game) => MainMenu(marioRun: game as MarioRun),
      'GameOverMenu': (_, game) => GameOverMenu(marioRun: game as MarioRun),
    },
  ));


}
