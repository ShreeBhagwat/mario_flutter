import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
    this.isEnemy = false,
    this.isObstacle = false,
    this.isPoint = false,
    this.isPowerUp = false,
  }) : super(position: position, size: size) {
    debugMode = true;
  }

  bool isPlatform;
  bool isEnemy;
  bool isObstacle;
  bool isPoint;
  bool isPowerUp;
}
