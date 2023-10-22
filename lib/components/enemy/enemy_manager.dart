import 'dart:math';

import 'package:flame/components.dart';
import 'package:mario_flutter/components/enemy/enemy.dart';
import 'package:mario_flutter/components/enemy/enemy_common.dart';
import 'package:mario_flutter/mario_run.dart';

class EnemyManager extends Component with HasGameRef<MarioRun> {
  late Random _random;
  late Timer _timer;

  EnemyManager() {
    _random = Random();
    _timer = Timer(3, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void update(double dt) {
    _timer.update(dt);

    super.update(dt);
  }

  void spawnRandomEnemy() {
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final enemyType = EnemyType.values[randomNumber];
    final enemy = Enemy(enemyType: enemyType);
    add(enemy);
  }


  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }
}
