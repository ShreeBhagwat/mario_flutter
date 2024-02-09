import 'package:flutter/material.dart';
import 'package:mario_flutter/mario_run.dart';

class GameOverMenu extends StatelessWidget {
  final MarioRun marioRun;
  const GameOverMenu({super.key, required this.marioRun});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 48,
                fontFamily: 'super_mario',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
             Text(
              marioRun.score.toString(),
              style: const TextStyle(
                fontSize: 48,
                fontFamily: 'super_mario',
                color: Colors.white,
              ),
            ),

           
          ],
        ),
      ),
    );
  }
}
