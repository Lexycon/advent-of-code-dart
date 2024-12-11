import 'dart:collection';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day06().solve();

class Day06 extends AdventDay {
  Day06() : super(2024, 6, name: 'Print Queue');

  @override
  dynamic part1(String input) {
    final GuardMap guardMap = GuardMap(input);
    return guardMap.solvePart1();
  }

  @override
  dynamic part2(String input) {
    final GuardMap guardMap = GuardMap(input);
    return guardMap.solvePart2();
  }
}

class GuardMap {
  late final List<List<MapObject>> grid;

  GuardMap(String input) {
    final lines = input.split('\n').map((e) => e.chars).toList();
    grid = lines.mapIndexed((y, line) {
      return line.mapIndexed((x, c) {
        return MapObject(Vec2.int(x, y), c);
      }).toList();
    }).toList();
  }

  List<(Vec2, Vec2)> getGridVisits() {
    Vec2 pos = grid.flattened.firstWhere((e) => e.isGuard).position;
    Vec2 dir = Vec2.up;

    final List<(Vec2, Vec2)> visits = [(pos, dir)];

    while (true) {
      final nPos = pos + dir;
      if (!_isValidPosition(nPos.xInt, nPos.yInt)) break;

      if (grid[nPos.yInt][nPos.xInt].isObstruction) {
        dir = dir.clockWise;
        continue;
      }

      pos = nPos;
      visits.add((pos, dir));
    }

    return visits;
  }

  int solvePart1() => getGridVisits().map((e) => e.$1).toSet().length;

  int solvePart2() {
    final List<(Vec2, Vec2)> visits = getGridVisits();

    // Contains all positions, where a obstruction generated a loop.
    Set<Vec2> positions = {};

    // Loop all visited positions. Each position is now tested as obstruction.
    for (int i = 0; i < visits.length; i++) {
      // print('$i / ${visits.length - 1}'); // Progress print

      // Set position to obstruction.
      final Vec2 obstructionPos = visits[i].$1;
      grid[obstructionPos.yInt][obstructionPos.xInt].symbol = '#';

      // Test new grid for a loop.
      final HashSet<(Vec2, Vec2)> visitHashSet = HashSet<(Vec2, Vec2)>();
      Vec2 pos = visits.first.$1;
      Vec2 dir = visits.first.$2;
      while (true) {
        final nPos = pos + dir;
        if (!_isValidPosition(nPos.yInt, nPos.xInt)) break;

        if (grid[nPos.yInt][nPos.xInt].isObstruction) {
          dir = dir.clockWise;
          continue;
        }

        pos = nPos;
        // Already visted? Loop!
        if (visitHashSet.contains((pos, dir))) {
          positions.add(obstructionPos);
          break;
        }
        visitHashSet.add((pos, dir));
      }

      // Reset position to non obstruction.
      grid[obstructionPos.yInt][obstructionPos.xInt].symbol = '.';
    }

    return positions.length;
  }

  bool _isValidPosition(int x, int y) {
    return x >= 0 && x < grid.first.length && y >= 0 && y < grid.length;
  }
}

class MapObject {
  final Vec2 position;
  String symbol;

  MapObject(this.position, this.symbol);

  bool get isObstruction => symbol == '#';
  bool get isGuard => symbol == '^';
}
