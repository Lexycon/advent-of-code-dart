import 'dart:math';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day21().solve();

class Day21 extends AdventDay {
  Day21() : super(2023, 21, name: 'Step Counter');

  @override
  dynamic part1(String input) {
    Graph graph = Graph(input);
    return graph.solve(isPart2: false, steps: 64);
  }

  @override
  dynamic part2(String input) {
    Graph graph = Graph(input);
    return graph.solve(isPart2: true, steps: 26501365);
  }
}

class Graph {
  late List<List<GridObj>> objects = [];

  Graph(String input) {
    final List<String> rows = input.split('\n').toList();

    for (int x = 0; x < rows.length; x++) {
      objects.add(rows.mapIndexed((y, e) {
        return GridObj(Vec2.int(x, y), e.chars[x]);
      }).toList());
    }
  }

  int solve({required bool isPart2, required int steps}) {
    final int height = objects.length;
    final int width = objects.first.length;

    final startObject = objects.flattened.firstWhere((e) => e.isStart);
    List<Vec2> queue = [startObject.position];

    Map<int, int> points = {};

    for (int s = 1; s <= steps; s++) {
      final Set<Vec2> newQueue = {};

      for (final position in queue) {
        for (final Vec2 dir in [Vec2.up, Vec2.down, Vec2.left, Vec2.right]) {
          final Vec2 nextPos = position + dir;

          // If part 1, grid is not infinite, so check borders.
          if (!isPart2 && !_validGridPos(nextPos)) continue;

          final obj = objects[nextPos.xInt % width][nextPos.yInt % height];
          if (obj.isRock) continue;

          newQueue.add(nextPos);
        }
      }

      queue = newQueue.toList();

      // Part 2 stuff.
      if (isPart2 && s % height == steps % height) {
        points[s ~/ height] = queue.length;
        if (points.length == 3) {
          return quadraticFn(points.values.toList(), steps ~/ height).toInt();
        }
      }
    }

    return queue.length;
  }

  double quadraticFn(List<int> p, int n) {
    double a = (p[2] + p[0] - 2 * p[1]) / 2;
    double b = p[1] - p[0] - a;
    int c = p[0];
    return a * pow(n, 2) + (b * n) + c;
  }

  bool _validGridPos(Vec2 v) =>
      v.xInt >= 0 &&
      v.xInt < objects.first.length &&
      v.yInt >= 0 &&
      v.yInt < objects.length;
}

class GridObj {
  final Vec2 position;
  final String symbol;

  const GridObj(this.position, this.symbol);

  bool get isStart => symbol == 'S';
  bool get isGardenPlot => symbol == '.';
  bool get isRock => symbol == '#';
}
