import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day03().solve();

class Day03 extends AdventDay {
  Day03() : super(2023, 3, name: 'Gear Ratios');

  @override
  dynamic part1(String input) {
    final Grid grid = Grid(input);
    return grid.getPartNumbersBySchemeSum();
  }

  @override
  dynamic part2(String input) {
    final Grid grid = Grid(input);
    return grid.getGearRatiosBySchemeSum();
  }
}

class Grid {
  late final List<String> data;
  late final List<PartNumber> partNumbers = [];

  Grid(String input) {
    data = input.lines.map((line) => line).toList();
    data.forEachIndexed((idx, line) {
      partNumbers.addAll(RegExp(r'(\d+)').allMatches(line).map((m) {
        return PartNumber(m.group(0)!, m.start, m.end - 1, idx);
      }).toList());
    });
  }

  int getPartNumbersBySchemeSum() {
    return partNumbers.map((n) {
      final adjacent = _isAdjacent(n.x1 - 1, n.x2 + 1, n.y - 1, n.y + 1);
      return adjacent ? n.value : 0;
    }).sum;
  }

  int getGearRatiosBySchemeSum() {
    return data.mapIndexed((idx, line) {
      return RegExp(r'(\*)').allMatches(line).map((m) {
        return _gearRatio(m.start, idx);
      }).sum;
    }).sum;
  }

  int _gearRatio(int x, int y) {
    final neighbors = partNumbers.where((n) {
      return n.x1 <= x + 1 && n.x2 >= x - 1 && n.y <= y + 1 && n.y >= y - 1;
    }).toList();
    if (neighbors.length != 2) return 0;
    return neighbors.map((e) => e.value).reduce((v, e) => v * e);
  }

  bool _isAdjacent(int x1, int x2, int y1, int y2) {
    for (int y = y1; y <= y2; y++) {
      for (int x = x1; x <= x2; x++) {
        if (!_isValidPosition(x, y)) continue;

        if (data[y][x].replaceAll(RegExp(r'[\d.]'), '').isNotEmpty) return true;
      }
    }
    return false;
  }

  bool _isValidPosition(int x, int y) {
    return x >= 0 && x < data.first.length && y >= 0 && y < data.length;
  }
}

class PartNumber {
  final String text;
  final int x1;
  final int x2;
  final int y;

  PartNumber(this.text, this.x1, this.x2, this.y);

  int get value => int.parse(text);
}
