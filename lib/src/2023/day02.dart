import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day02().solve();

class Day02 extends AdventDay {
  Day02() : super(2023, 2, name: 'Cube Conundrum');

  @override
  dynamic part1(String input) => input.lines
      .mapIndexed(parse)
      .where((e) => e.isPossible({'red': 12, 'green': 13, 'blue': 14}))
      .map((e) => e.id)
      .sum;

  @override
  dynamic part2(String input) =>
      input.lines.mapIndexed(parse).map((e) => e.power).sum;

  Game parse(int idx, String line) {
    const List<String> colors = ['red', 'green', 'blue'];
    final Game game = Game(idx + 1);

    line.split(';').forEach((set) {
      for (String color in colors) {
        final match = RegExp('(\\d+) $color').allMatches(set).firstOrNull;
        final int amount = match != null ? int.parse('${match.group(1)}') : 0;
        if ((game.maxCubes[color] ?? 0) < amount) game.maxCubes[color] = amount;
      }
    });

    return game;
  }
}

class Game {
  final int id;
  final Map<String, int> maxCubes = {};

  Game(this.id);

  bool isPossible(Map<String, int> reqCubes) {
    for (MapEntry<String, int> entry in maxCubes.entries) {
      if (reqCubes[entry.key]! < entry.value) return false;
    }
    return true;
  }

  int get power => maxCubes.values.reduce((v, e) => v * e);
}
