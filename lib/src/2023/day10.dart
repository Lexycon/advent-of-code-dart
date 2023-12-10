import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/math.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day10().solve();

class Day10 extends AdventDay {
  Day10() : super(2023, 10, name: 'Pipe Maze');

  @override
  dynamic part1(String input) {
    final Maze maze = Maze(input);
    return maze.farthestDistance();
  }

  @override
  dynamic part2(String input) {
    final Maze maze = Maze(input);
    return maze.sumInnerPoints();
  }
}

class Maze {
  static const startDirs = [Vec2.left, Vec2.up, Vec2.right, Vec2.down];
  late final List<Pipe> pipes;

  Maze(String input) {
    final lines = input.split('\n');
    final iterablePipes = lines.mapIndexed(
      (y, line) => line.chars.mapIndexed((x, char) {
        return Pipe(Vec2(x.toDouble(), y.toDouble()), char);
      }),
    );
    pipes = iterablePipes.flattened.toList();
  }

  int farthestDistance() {
    final Pipe startPipe = pipes.firstWhere((p) => p.symbol == 'S');
    return startDirs.map((dir) => _loop(startPipe, dir).length).max ~/ 2;
  }

  int sumInnerPoints() {
    final Pipe startPipe = pipes.firstWhere((p) => p.symbol == 'S');
    final List<Vec2> points = startDirs
        .map((dir) => _loop(startPipe, dir))
        .reduce((v, e) => v.length > e.length ? v : e);

    final double area = polygonArea(points);
    return polygonPointsInside(area, points.length - 1).toInt();
  }

  List<Vec2> _loop(Pipe pipe, Vec2 dir) {
    List<Vec2> points = [pipe.position];

    while (true) {
      final fromPos = points.last;
      final nextPos = fromPos + dir;
      points.add(nextPos);
      final Pipe? pipe = pipes.firstWhereOrNull((e) => e.position == nextPos);

      Vec2 relativeDir = nextPos - fromPos;
      if (pipe == null || !_isConnected(pipe.symbol, relativeDir)) break;

      dir = _nextDir(pipe.symbol, relativeDir);
    }
    return points;
  }

  Vec2 _nextDir(String symbol, Vec2 v) {
    return switch (symbol) {
      '|' => Vec2.up == v ? Vec2.up : Vec2.down,
      '-' => Vec2.left == v ? Vec2.left : Vec2.right,
      'L' => Vec2.down == v ? Vec2.right : Vec2.up,
      'J' => Vec2.down == v ? Vec2.left : Vec2.up,
      '7' => Vec2.up == v ? Vec2.left : Vec2.down,
      'F' => Vec2.up == v ? Vec2.right : Vec2.down,
      _ => Vec2.zero,
    };
  }

  bool _isConnected(String symbol, Vec2 v) {
    return switch (symbol) {
      '|' => Vec2.up == v || Vec2.down == v,
      '-' => Vec2.left == v || Vec2.right == v,
      'L' => Vec2.down == v || Vec2.left == v,
      'J' => Vec2.down == v || Vec2.right == v,
      '7' => Vec2.up == v || Vec2.right == v,
      'F' => Vec2.up == v || Vec2.left == v,
      _ => false,
    };
  }
}

class Pipe {
  final Vec2 position;
  final String symbol;

  Pipe(this.position, this.symbol);
}
