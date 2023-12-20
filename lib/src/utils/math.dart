import 'package:advent_of_code_dart/src/utils/vec2.dart';

int lcm(int a, int b) => (a * b) ~/ a.gcd(b);
int gcd(int a, int b) => a.gcd(b);

double cross(double x1, double y1, double x2, double y2) {
  return x1 * y2 - x2 * y1;
}

double polygonArea(List<Vec2> points) {
  double a = 0.0;
  for (int i = 2; i < points.length; i++) {
    a += cross(points[i].x - points[0].x, points[i].y - points[0].y,
        points[i - 1].x - points[0].x, points[i - 1].y - points[0].y);
  }
  return (a / 2).abs();
}

double polygonPointsInside(double area, int pointsBoundary) {
  return area + 1 - pointsBoundary / 2;
}

int shoelaceArea(List<Vec2> points) {
  double perimeter = 0;
  double area = 0;
  for (int i = 0; i < points.length - 1; i++) {
    perimeter += points[i].manhattanDistanceTo(points[i + 1]);
    area += points[i].x * points[i + 1].y - points[i + 1].x * points[i].y;
  }
  return (perimeter + area) ~/ 2 + 1;
}
