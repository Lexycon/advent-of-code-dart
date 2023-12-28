import 'dart:collection';
import 'dart:math';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day23().solve();

class Day23 extends AdventDay {
  Day23() : super(2023, 23, name: 'A Long Walk');

  @override
  dynamic part1(String input) {
    Grid grid = Grid(input);
    // return grid.solveBruteforce(withSlopes: true);
    return grid.solveJunctionGraph(withSlopes: true);
  }

  @override
  dynamic part2(String input) {
    Grid grid = Grid(input);
    return grid.solveJunctionGraph(withSlopes: false);
  }
}

class Grid {
  late List<List<GridObj>> objects = [];
  late final GridObj startObj;
  late final GridObj endObj;

  Grid(String input) {
    final List<String> rows = input.split('\n').toList();

    for (int x = 0; x < rows.length; x++) {
      objects.add(rows.mapIndexed((y, e) {
        return GridObj(Vec2.int(x, y), e.chars[x]);
      }).toList());
    }
    startObj = objects.flattened.firstWhere(
      (e) => e.isPath && e.position.yInt == 0,
    );
    endObj = objects.flattened.firstWhere(
      (e) => e.isPath && e.position.yInt == rows.length - 1,
    );
  }

  // Slow (couple of seconds), storing full traveled path, a junction will
  // create a new path with current visited positions to avoid running over
  // tiles multiple times. (Storing just junctions as 'visited' would probably
  // be smarter.) Impossible to calculate part 2.
  int solveBruteforce({required bool withSlopes}) {
    final List<Set<Vec2>> queue = [
      {startObj.position}
    ];

    int result = 0;
    while (queue.isNotEmpty) {
      for (int i = queue.length - 1; i >= 0; i--) {
        final Set<Vec2> path = queue[i];

        if (path.last == endObj.position) {
          if (path.length > result) {
            result = path.length - 1;
          }
          queue.removeAt(i);
          continue;
        }

        final positions = _getNextPositions(path, withSlopes);
        if (positions.isNotEmpty) {
          // If positions > 1 -> add new paths for other junction directions.
          for (int i = 1; i < positions.length; i++) {
            queue.add(path.union(positions[i]));
          }
          // Current path continues with first direction (same for no junction).
          path.addAll(positions.first);
        } else {
          // Deadlock.
          queue.removeAt(i);
        }
      }
    }

    return result;
  }

  /// Build graph with all junctions.
  int solveJunctionGraph({required bool withSlopes}) {
    final Map<Vec2, List<(Vec2, int)>> graph = {};

    final Set<Vec2> seen = {};
    final Queue<Vec2> queue = Queue()..add(startObj.position);
    while (queue.isNotEmpty) {
      final Vec2 node = queue.removeFirst();
      if (seen.contains(node)) continue;
      seen.add(node);

      final Set<(Vec2, int)> junctions = _findJunctions(node, withSlopes);
      for (final junction in junctions) {
        if (!graph.containsKey(node)) graph[node] = [];
        graph[node]!.add(junction);

        if (!seen.contains(junction.$1)) queue.add(junction.$1);
      }
    }

    return _findLongestPathInGraph(graph);
  }

  Set<(Vec2, int)> _findJunctions(Vec2 start, bool withSlopes) {
    final Set<(Vec2, int)> junctions = {};
    final List<PathObj> queue = [
      PathObj(start, {start}, 0)
    ];
    while (queue.isNotEmpty) {
      final PathObj obj = queue.removeAt(0);
      if ((obj.position == endObj.position ||
              obj.position == startObj.position) &&
          obj.position != start) {
        junctions.add((obj.position, obj.length));
        continue;
      }

      final positions = _getNextPositions(obj.seen, withSlopes);
      if (positions.length > 1 && obj.position != start) {
        junctions.add((obj.position, obj.length));
        continue;
      }

      for (final nextPos in positions) {
        queue.add(PathObj(
          nextPos.last,
          obj.seen.union(nextPos),
          obj.length + nextPos.length,
        ));
      }
    }

    return junctions;
  }

  /// Pretty slow, like 30s for the solution.
  int _findLongestPathInGraph(Map<Vec2, List<(Vec2, int)>> graph) {
    int maxLength = 0;
    final Queue<PathObj> queue = Queue();
    queue.add(PathObj(startObj.position, {startObj.position}, 0));
    while (queue.isNotEmpty) {
      final PathObj obj = queue.removeFirst();

      if (obj.position == endObj.position) {
        maxLength = max(maxLength, obj.length);
        continue;
      }
      for (final n in graph[obj.position]!) {
        if (!obj.seen.contains(n.$1)) {
          queue.add(PathObj(n.$1, obj.seen.union({n.$1}), obj.length + n.$2));
        }
      }
    }
    return maxLength;
  }

  // Might return multiple positions for one direction (slope jump).
  List<Set<Vec2>> _getNextPositions(Set<Vec2> path, bool slopes) {
    List<Set<Vec2>> positions = [];
    for (final Vec2 dir in [Vec2.down, Vec2.up, Vec2.left, Vec2.right]) {
      Vec2 nextPos = path.last + dir;
      if (!_validGridPos(nextPos) || path.contains(nextPos)) continue;

      final nextObj = objects[nextPos.xInt][nextPos.yInt];
      if (nextObj.isForest) continue;
      if (slopes) {
        if (nextObj.isValidSlope(dir)) positions.add({nextPos, nextPos + dir});
        if (nextObj.isPath) positions.add({nextPos});
      } else {
        positions.add({nextPos});
      }
    }
    return positions;
  }

  bool _validGridPos(Vec2 v) =>
      v.xInt >= 0 &&
      v.xInt < objects.first.length &&
      v.yInt >= 0 &&
      v.yInt < objects.length;
}

class PathObj {
  final Vec2 position;
  final Set<Vec2> seen;
  final int length;

  const PathObj(this.position, this.seen, this.length);
}

class GridObj {
  final Vec2 position;
  final String symbol;

  const GridObj(this.position, this.symbol);

  bool get isForest => symbol == '#';
  bool get isPath => symbol == '.';

  bool isValidSlope(Vec2 dir) {
    return switch (symbol) {
      '>' => dir == Vec2.right,
      '<' => dir == Vec2.left,
      '^' => dir == Vec2.up,
      'v' => dir == Vec2.down,
      _ => false,
    };
  }
}
