import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day14().solve();

class Day14 extends AdventDay {
  Day14() : super(2023, 14, name: 'Parabolic Reflector Dish');

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
  late List<List<GridObj>> objects;

  Grid(String input) {
    final lines = input.split('\n').map((e) => e.chars).toList();
    objects = lines.map((line) {
      return line.map((c) => GridObj(c)).toList();
    }).toList();
  }

  List<List<GridObj>> _rotateCounterClockWise(List<List<GridObj>> input) {
    const GridObj emptyObj = GridObj('');
    var iW = input.length;
    var iH = input.first.length;

    List<List<GridObj>> output = List.generate(iH, (i) {
      return List.generate(iW, (i) => emptyObj);
    });

    for (int j = 0; j < iW; j++) {
      for (int i = 0; i < iH; i++) {
        output[i][j] = input[iW - 1 - j][i];
      }
    }

    return output;
  }

  void _tilt() {
    for (int x = 0; x < objects.first.length; x++) {
      int? pos;
      for (int y = 0; y < objects.length; y++) {
        final obj = objects[y][x];

        if (obj.isRound && pos != null) {
          objects[y][x] = objects[pos][x];
          objects[pos][x] = obj;
          y = pos;
          pos = null;
        } else if (obj.isSpace && pos == null) {
          pos = y;
        } else if (obj.isCube) {
          pos = null;
        }
      }
    }
  }

  void _cycle() {
    for (int i = 0; i < 4; i++) {
      _tilt();
      objects = _rotateCounterClockWise(objects);
    }
  }

  int solvePart1() {
    _tilt();
    return totalLoadNorthSupportBeams;
  }

  int solvePart2() {
    final List<String> seenGridIds = [];
    String currentGridId = '';
    int iterations = 0;
    while (!seenGridIds.contains(currentGridId)) {
      iterations++;
      seenGridIds.add(currentGridId);
      _cycle();

      currentGridId = objects.map((e) => e.map((e) => e.symbol).join()).join();
    }

    // Loop found, calculate how many tilts we have to do to match the same grid
    // as [iterationNumber].
    const int iterationNumber = 1000000000;
    final int foundCycle = seenGridIds.indexOf(currentGridId);
    final int loopSize = (iterations - foundCycle);
    final int missingIterations = ((iterationNumber - foundCycle) % loopSize);

    for (int i = 0; i < missingIterations; i++) {
      _cycle();
    }

    return totalLoadNorthSupportBeams;
  }

  int get totalLoadNorthSupportBeams {
    return objects.mapIndexed((i, e) {
      return e.where((e) => e.isRound).length * (objects.length - i);
    }).sum;
  }
}

class GridObj {
  final String symbol;

  const GridObj(this.symbol);

  bool get isRound => symbol == 'O';
  bool get isCube => symbol == '#';
  bool get isSpace => symbol == '.';
}
