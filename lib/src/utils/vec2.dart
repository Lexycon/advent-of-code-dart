class Vec2 {
  const Vec2(this.x, this.y);

  Vec2.int(int x, int y)
      : x = x.toDouble(),
        y = y.toDouble();

  final double x;
  final double y;

  int get xInt => x.toInt();
  int get yInt => y.toInt();

  static const Vec2 zero = Vec2(0, 0);
  static const Vec2 up = Vec2(0, -1);
  static const Vec2 upRight = Vec2(1, -1);
  static const Vec2 right = Vec2(1, 0);
  static const Vec2 downRight = Vec2(1, 1);
  static const Vec2 down = Vec2(0, 1);
  static const Vec2 downLeft = Vec2(-1, 1);
  static const Vec2 left = Vec2(-1, 0);
  static const Vec2 upLeft = Vec2(-1, -1);

  static const List<Vec2> cardinalDirs = <Vec2>[
    Vec2.upLeft,
    Vec2.up,
    Vec2.upRight,
    Vec2.left,
    Vec2.zero,
    Vec2.right,
    Vec2.downLeft,
    Vec2.down,
    Vec2.downRight,
  ];

  static const List<Vec2> aroundDirs = <Vec2>[
    Vec2.upLeft,
    Vec2.up,
    Vec2.upRight,
    Vec2.left,
    Vec2.right,
    Vec2.downLeft,
    Vec2.down,
    Vec2.downRight,
  ];

  Vec2 operator +(Vec2 other) => Vec2(x + other.x, y + other.y);

  Vec2 operator -() => Vec2(-x, -y);

  Vec2 operator -(Vec2 other) => Vec2(x - other.x, y - other.y);

  Vec2 operator *(num factor) => Vec2(x * factor, y * factor);

  static Iterable<Vec2> range(Vec2 min, Vec2 max) sync* {
    for (int y = min.yInt; y < max.yInt; y++) {
      for (int x = min.xInt; x < max.xInt; x++) {
        yield Vec2.int(x, y);
      }
    }
  }

  double manhattanDistanceTo(Vec2 other) =>
      (x - other.x).abs() + (y - other.y).abs();

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is Vec2 &&
          other.runtimeType == runtimeType &&
          other.x == x &&
          other.y == y);

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'Vec2($x, $y)';
}
