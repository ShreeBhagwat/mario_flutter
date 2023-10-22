enum EnemyType { goomba, greenDuck, redDuck, browser, flame }

class EnemyCommonData {
  final String imagePath;
  final double height;
  final double width;
  final double offsetX;
  final double offsetY;
  final double stepTime;
  final double hitBoxOffsetX;
  final double hitBoxOffsetY;
  final double hitBoxWidth;
  final double hitBoxHeight;
  final int nRows;
  final int nColumns;
  final int walkFrom;
  final int walkTo;
  final int deadFrom;
  final int deadTo;
  final bool isFlying;
  final bool willDie;
  final int moveSpeed;

  const EnemyCommonData( 
      {required this.imagePath,
      required this.height,
      required this.width,
      required this.offsetX,
      required this.offsetY,
      required this.stepTime,
      required this.nRows,
      required this.nColumns,
      required this.walkFrom,
      required this.walkTo,
      required this.deadFrom,
      required this.deadTo,
      this.isFlying = false,
      this.willDie = true,
      this.moveSpeed = 100,
      this.hitBoxOffsetX = 10, 
      this.hitBoxOffsetY = 0, 
      this.hitBoxWidth = 70, 
      this.hitBoxHeight = 70,
      });
}
