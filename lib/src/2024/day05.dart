import 'package:advent_of_code_dart/src/day.dart';
import 'package:collection/collection.dart';

main() => Day05().solve();

class Day05 extends AdventDay {
  Day05() : super(2024, 5, name: 'Print Queue');

  @override
  dynamic part1(String input) {
    final PrintQueue printQueue = PrintQueue(input);
    return printQueue.solve();
  }

  @override
  dynamic part2(String input) {
    final PrintQueue printQueue = PrintQueue(input);
    return printQueue.solvePart2();
  }
}

class PrintQueue {
  Map<int, List<int>> rules = {};
  List<List<int>> updates = [];

  PrintQueue(String input) {
    final List<String> split = input.split('\n\n');

    final re = RegExp(r'(\d+)\|(\d+)');
    re.allMatches(split.first).forEach((m) {
      final int page1 = int.parse(m[1]!);
      final int page2 = int.parse(m[2]!);
      rules.putIfAbsent(page1, () => []).add(page2);
    });

    for (String line in split.last.split('\n')) {
      updates.add(line.split(',').map((e) => int.parse(e)).toList());
    }
  }

  int solve() {
    return updates.where((update) => isValid(update)).map((update) {
      return update[update.length ~/ 2];
    }).sum;
  }

  int solvePart2() {
    return updates.where((update) => !isValid(update)).map((update) {
      fixIncorrect(update);
      return update[update.length ~/ 2];
    }).sum;
  }

  bool isValid(List<int> update) {
    for (int i = 1; i < update.length; i++) {
      final List<int>? rule = rules[update[i]];
      if (rule == null) continue;

      if (update.sublist(0, i).any((e) => rule.contains(e))) return false;
    }
    return true;
  }

  void fixIncorrect(List<int> update) {
    for (int i = 1; i < update.length; i++) {
      final List<int>? rule = rules[update[i]];
      if (rule == null) continue;

      for (int j = 0; j < i; j++) {
        if (rule.contains(update[j])) update.swap(i, j);
      }
    }
  }
}
