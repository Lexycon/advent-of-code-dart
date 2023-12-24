import 'dart:math';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec3.dart';

main() => Day22().solve();

class Day22 extends AdventDay {
  Day22() : super(2023, 22, name: 'Sand Slabs');

  @override
  dynamic part1(String input) {
    Grid grid = Grid(input);
    return grid.solvePart1();
  }

  @override
  dynamic part2(String input) {
    Grid grid = Grid(input);
    return grid.solvePart2();
  }
}

class Grid {
  late final List<List<List<int>>> grid;
  late final List<Brick> bricks;

  Grid(String input) {
    final List<String> rows = input.split('\n').toList();

    bricks = rows.map((row) {
      final matches = RegExp(r'(\d+)').allIntMatches(row);
      return Brick(matches);
    }).toList();

    // Sort by lowest z of brick -> low to high
    bricks.sort((a, b) => a.from.z.compareTo(b.from.z));
    final int zMax = bricks.map((e) => e.to.zInt).reduce(max);
    final int yMax = bricks.map((e) => e.to.yInt).reduce(max);
    final int xMax = bricks.map((e) => e.to.xInt).reduce(max);

    grid = List.generate(zMax + 1, (_) {
      return List.generate(yMax + 1, (_) {
        return List.generate(xMax + 1, (_) => -1);
      });
    });
  }

  Map<String, Set<int>> dropBricksAndGetSupports() {
    final Map<String, Set<int>> supports = {};

    for (final (int id, Brick brick) in bricks.indexed) {
      int z = 0;
      // Drop brick until it reaches support
      for (0; z < grid.length - 1; z++) {
        final Set<int> support = {};
        for (int y = brick.from.yInt; y < brick.to.yInt + 1; y++) {
          for (int x = brick.from.xInt; x < brick.to.xInt + 1; x++) {
            if (grid[z][x][y] != -1) support.add(grid[z][x][y]);
          }
        }
        if (support.isNotEmpty) {
          supports['$id'] = support;
          break;
        }
      }

      // Add brick above its support
      final int height = brick.to.zInt - brick.from.zInt + 1;
      for (int y = brick.from.yInt; y < brick.to.yInt + 1; y++) {
        for (int x = brick.from.xInt; x < brick.to.xInt + 1; x++) {
          for (int z2 = z - height; z2 < z; z2++) {
            grid[z2][x][y] = id;
          }
        }
      }
    }

    return supports;
  }

  int solvePart1() {
    final supports = dropBricksAndGetSupports();

    // If a brick is only supported by one brick -> this supporting brick can be
    // removed.
    final cantDisintegrate = supports.values
        .where((e) => e.length == 1)
        .reduce((v, e) => v.union(e));

    return bricks.length - cantDisintegrate.length;
  }

  int solvePart2() {
    final supports = dropBricksAndGetSupports();

    final cantDisintegrate = supports.values
        .where((e) => e.length == 1)
        .reduce((v, e) => v.union(e));

    int sum = 0;
    for (final int id in cantDisintegrate) {
      var disintegrated = <int>{id};
      for (int i = id + 1; i < bricks.length; i++) {
        if (!supports.containsKey('$i')) continue;
        if (disintegrated.containsAll(supports['$i']!)) {
          disintegrated.add(i);
        }
      }
      sum += disintegrated.length - 1;
    }

    return sum;
  }
}

class Brick {
  final Vec3 from;
  final Vec3 to;

  Brick(List<int> v)
      : from = Vec3.int(min(v[0], v[3]), min(v[1], v[4]), min(v[2], v[5])),
        to = Vec3.int(max(v[0], v[3]), max(v[1], v[4]), max(v[2], v[5]));
}
