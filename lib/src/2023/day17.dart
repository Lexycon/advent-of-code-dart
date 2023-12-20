import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day17().solve();

class Day17 extends AdventDay {
  Day17() : super(2023, 17, name: 'Clumsy Crucible');

  @override
  dynamic part1(String input) {
    Graph graph = Graph(input);
    return graph.dijkstraAdv(maxBlocksPerDir: 3, minBlocksPerDir: 0);
  }

  @override
  dynamic part2(String input) {
    Graph graph = Graph(input);
    return graph.dijkstraAdv(maxBlocksPerDir: 10, minBlocksPerDir: 4);
  }
}

class Graph {
  late List<List<int>> vertices = [];

  Graph(String input) {
    final List<String> rows = input.split('\n').toList();
    for (int x = 0; x < rows.length; x++) {
      vertices.add(rows.map((e) => int.parse(e.chars[x])).toList());
    }
  }

  int dijkstraAdv({
    required int maxBlocksPerDir,
    required int minBlocksPerDir,
  }) {
    final HeapPriorityQueue<Vertex> heap = HeapPriorityQueue<Vertex>(
      (v1, v2) => v1.heatLoss.compareTo(v2.heatLoss),
    );

    final destPosition = Vec2(vertices.first.length - 1, vertices.length - 1);
    final Map<String, bool> seen = {};

    final Vertex v1 = Vertex(Vec2.zero, Vec2.zero, Vec2.down, 0, 0);
    heap.add(v1);

    while (heap.length > 0) {
      final Vertex v = heap.removeFirst();

      if (v.position == destPosition) {
        if (v.steps >= minBlocksPerDir) return v.heatLoss;
      }

      final String hash = v.toString();
      if (seen.containsKey(hash)) continue;

      for (final Vec2 nextDir in [Vec2.up, Vec2.down, Vec2.left, Vec2.right]) {
        Vec2 nextPos = v.position + nextDir;

        if (!_validGridPos(nextPos)) continue;
        if (v.prevPosition == nextPos) continue;

        final int heatLoss = v.heatLoss + vertices[nextPos.xInt][nextPos.yInt];

        if (v.dir == nextDir) {
          if (v.steps < maxBlocksPerDir) {
            heap.add(Vertex(nextPos, v.position, v.dir, v.steps + 1, heatLoss));
          }
        } else {
          if (v.steps >= minBlocksPerDir || v.position == Vec2.zero) {
            heap.add(Vertex(nextPos, v.position, nextDir, 1, heatLoss));
          }
        }
      }
      seen.putIfAbsent(hash, () => true);
    }

    return 0;
  }

  bool _validGridPos(Vec2 v) =>
      v.xInt >= 0 &&
      v.xInt < vertices.first.length &&
      v.yInt >= 0 &&
      v.yInt < vertices.length;
}

class Vertex {
  final Vec2 position;
  final Vec2 prevPosition;
  final Vec2 dir;
  final int heatLoss;
  final int steps;

  Vertex(this.position, this.prevPosition, this.dir, this.steps, this.heatLoss);

  @override
  String toString() => '$position$dir$steps';
}
