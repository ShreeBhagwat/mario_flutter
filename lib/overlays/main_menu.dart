import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:mario_flutter/mario_run.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.marioRun});

  final MarioRun marioRun;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mario Run',
              style: TextStyle(
                fontSize: 48,
                fontFamily: 'super_mario',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                marioRun.overlays.remove('MainMenu');
                marioRun.resumeEngine();
                if (marioRun.playSounds) {
                  FlameAudio.bgm.play('mario_theme.mp3',
                      volume: marioRun.soundVolume * 0.7);
                }
              },
              child: const Text('Start'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                marioRun.overlays.remove('MainMenu');
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
