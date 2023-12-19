import 'dart:math';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';
import 'package:collection/collection.dart';

main() => Day16().solve();

class Day16 extends AdventDay {
  Day16() : super(2023, 16, name: 'The Floor Will Be Lava');

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
  late List<List<GridObj>> objects = [];

  Grid(String input) {
    final List<String> rows = input.split('\n').toList();
    for (int x = 0; x < rows.length; x++) {
      objects.add(rows.mapIndexed((y, e) {
        return GridObj(Vec2.int(x, y), e.chars[x]);
      }).toList());
    }
  }

  int solvePart1() {
    return _start(Vec2.int(0, 0), Vec2.right);
  }

  int solvePart2() {
    int r = 0;
    for (int i = 0; i < objects.first.length; i++) {
      r = max(r, _start(Vec2.int(i, 0), Vec2.down));
      r = max(r, _start(Vec2.int(i, objects.first.length - 1), Vec2.up));
    }
    for (int j = 0; j < objects.length; j++) {
      r = max(r, _start(Vec2.int(0, j), Vec2.right));
      r = max(r, _start(Vec2.int(objects.length - 1, j), Vec2.left));
    }
    return r;
  }

  int _start(Vec2 position, Vec2 dir) {
    for (int i = 0; i < objects.first.length; i++) {
      for (int j = 0; j < objects.length; j++) {
        objects[i][j].visits.clear();
      }
    }
    _move(position, dir);
    return objects.map((e) => e.where((e) => e.visits.isNotEmpty).length).sum;
  }

  void _move(Vec2 position, Vec2 dir) {
    if (!_validGridPos(position)) return;

    final obj = objects[position.xInt][position.yInt];
    if (obj.hasVisitedFrom(dir)) return;

    if (obj.isSpace) {
      final Vec2 nextPos = obj.position + dir;
      _move(nextPos, dir);
    } else if (obj.isMirror) {
      final nextDir = _getMirrorNextDir(obj.symbol, dir);
      final Vec2 nextPos = obj.position + nextDir;
      _move(nextPos, nextDir);
    } else if (obj.isSplitter) {
      final List<Vec2> nextDirs = _getSplitterNextDir(obj.symbol, dir);
      for (Vec2 nextDir in nextDirs) {
        final Vec2 nextPos = obj.position + nextDir;
        _move(nextPos, nextDir);
      }
    }
  }

  Vec2 _getMirrorNextDir(String symbol, Vec2 v) {
    return switch (v) {
      Vec2.right => symbol == '/' ? Vec2.up : Vec2.down,
      Vec2.left => symbol == '/' ? Vec2.down : Vec2.up,
      Vec2.up => symbol == '/' ? Vec2.right : Vec2.left,
      Vec2.down => symbol == '/' ? Vec2.left : Vec2.right,
      _ => Vec2.zero,
    };
  }

  List<Vec2> _getSplitterNextDir(String symbol, Vec2 v) {
    return switch (v) {
      Vec2.right => symbol == '|' ? [Vec2.up, Vec2.down] : [Vec2.right],
      Vec2.left => symbol == '|' ? [Vec2.up, Vec2.down] : [Vec2.left],
      Vec2.up => symbol == '-' ? [Vec2.left, Vec2.right] : [Vec2.up],
      Vec2.down => symbol == '-' ? [Vec2.left, Vec2.right] : [Vec2.down],
      _ => [],
    };
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
  final List<Vec2> visits = [];

  GridObj(this.position, this.symbol);

  bool get isSpace => symbol == '.';
  bool get isMirror => symbol == '/' || symbol == r'\';
  bool get isSplitter => symbol == '-' || symbol == '|';

  bool hasVisitedFrom(Vec2 dir) {
    bool visitedFrom = visits.contains(dir);
    if (!visitedFrom) visits.add(dir);
    return visitedFrom;
  }
}
