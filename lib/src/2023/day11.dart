import 'dart:math';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/combinatorics.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day11().solve();

class Day11 extends AdventDay {
  Day11() : super(2023, 11, name: 'Cosmic Expansion');

  @override
  dynamic part1(String input) {
    final Cosmos cosmos = Cosmos(input);
    return cosmos.solve(multiplier: 2);
  }

  @override
  dynamic part2(String input) {
    final Cosmos cosmos = Cosmos(input);
    return cosmos.solve(multiplier: 1000000);
  }
}

class Cosmos {
  late final List<List<GalaxyObj>> objects;

  Cosmos(String input) {
    final lines = input.split('\n').map((e) => e.chars).toList();
    objects = lines.mapIndexed((y, line) {
      return line.mapIndexed((x, c) {
        return GalaxyObj(Vec2.int(x, y), c);
      }).toList();
    }).toList();
  }

  int solve({required int multiplier}) {
    final galaxies = objects.flattened.where((e) => e.isGalaxy).toList();

    int sum = 0;
    for (final combination in combinations(galaxies, 2)) {
      final Vec2 p1 = combination.first.position;
      final Vec2 p2 = combination.last.position;

      sum += p1.manhattanDistanceTo(p2).toInt();

      sum += getEmptyRowsBetween(p1.yInt, p2.yInt) * (multiplier - 1);
      sum += getEmptyColumnsBetween(p1.xInt, p2.xInt) * (multiplier - 1);
    }

    return sum;
  }

  int getEmptyRowsBetween(int y1, int y2) {
    return objects.getRange(min(y1, y2), max(y1, y2)).where((e) {
      return e.every((e) => e.isSpace);
    }).length;
  }

  int getEmptyColumnsBetween(int x1, int x2) {
    int counter = 0;
    for (int i = min(x1, x2); i < max(x1, x2); i++) {
      if (objects.map((e) => e[i]).every((e) => e.isSpace)) counter++;
    }
    return counter;
  }
}

class GalaxyObj {
  final Vec2 position;
  final String symbol;

  GalaxyObj(this.position, this.symbol);

  bool get isGalaxy => symbol == '#';
  bool get isSpace => symbol == '.';
}
