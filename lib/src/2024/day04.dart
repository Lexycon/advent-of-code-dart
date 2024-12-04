import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day04().solve();

class Day04 extends AdventDay {
  Day04() : super(2024, 4, name: 'Ceres Search');

  @override
  dynamic part1(String input) {
    final WordSearch wordSearch = WordSearch(input);
    return wordSearch.solvePart1();
  }

  @override
  dynamic part2(String input) {
    final WordSearch wordSearch = WordSearch(input);
    return wordSearch.solvePart2();
  }
}

class WordSearch {
  late final List<List<String>> data;

  WordSearch(String input) {
    data = input.split('\n').map((e) => e.chars).toList();
  }

  int solvePart1() {
    int matches = 0;

    // left <-> right
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data.first.length - 3; j++) {
        final List<String> text = data[i].sublist(j, j + 4);
        if (verifyXMAS(text)) matches++;
      }
    }

    // top <-> down
    for (int i = 0; i < data.first.length - 3; i++) {
      for (int j = 0; j < data.length; j++) {
        final text = List.generate(4, (i) => i).map((e) => data[i + e][j]);
        if (verifyXMAS(text.toList())) matches++;
      }
    }

    // diagonal: top left <-> right bottom
    for (int i = 0; i < data.first.length - 3; i++) {
      for (int j = 0; j < data.length - 3; j++) {
        final text = _getDiagonalToRight(i, j, 4);
        if (verifyXMAS(text)) matches++;
      }
    }

    // diagonal: top right <-> left bottom
    for (int i = 3; i < data.first.length; i++) {
      for (int j = 0; j < data.length - 3; j++) {
        final text = _getDiagonalToLeft(i, j, 4);
        if (verifyXMAS(text)) matches++;
      }
    }

    return matches;
  }

  int solvePart2() {
    int matches = 0;

    for (int i = 0; i < data.first.length - 2; i++) {
      for (int j = 0; j < data.length - 2; j++) {
        final text1 = _getDiagonalToRight(i, j, 3);
        final text2 = _getDiagonalToLeft(i + 2, j, 3);
        if (verifyMAS(text1) && verifyMAS(text2)) matches++;
      }
    }

    return matches;
  }

  /// Start position: [x][y] -> moves down + left by [l]
  List<String> _getDiagonalToLeft(int x, int y, int l) {
    return List.generate(l, (i) => i).map((k) => data[x - k][y + k]).toList();
  }

  /// Start position: [x][y] -> moves down + right by [l]
  List<String> _getDiagonalToRight(int x, int y, int l) {
    return List.generate(l, (i) => i).map((k) => data[x + k][y + k]).toList();
  }

  bool verifyXMAS(List<String> text) =>
      ['X', 'M', 'A', 'S'].equals(text) || ['S', 'A', 'M', 'X'].equals(text);

  bool verifyMAS(List<String> text) =>
      ['M', 'A', 'S'].equals(text) || ['S', 'A', 'M'].equals(text);
}
