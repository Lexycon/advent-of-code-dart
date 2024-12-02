import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day02().solve();

class Day02 extends AdventDay {
  Day02() : super(2024, 2, name: 'Red-Nosed Reports');

  @override
  dynamic part1(String input) {
    final UnusualData data = UnusualData(input);
    return data.getSafeReports();
  }

  @override
  dynamic part2(String input) {
    final UnusualData data = UnusualData(input);
    return data.getSafeReportsWithToleration();
  }
}

class UnusualData {
  final List<Report> reports = [];

  UnusualData(String input) {
    for (String line in input.split('\n')) {
      final re = RegExp(r'(\d+)');
      final numbers = re.allIntMatches(line).toList();
      reports.add(Report(numbers));
    }
  }

  int getSafeReports() {
    return reports.where((r) => r.isSafe()).length;
  }

  int getSafeReportsWithToleration() {
    return reports.where((r) => r.isSafeWithToleration()).length;
  }
}

class Report {
  final List<int> levels;

  Report(this.levels);

  bool isSafeWithToleration() {
    for (int j = 0; j < levels.length; j++) {
      if (isSafe(j)) return true;
    }
    return false;
  }

  bool isSafe([int? ignoreLevel]) {
    final List<int> levels = this.levels.whereIndexed((i, _) {
      return i != ignoreLevel;
    }).toList();

    bool increased = levels[1] > levels[0];
    for (int i = 1; i < levels.length; i++) {
      final int l2 = levels[i];
      final int l1 = levels[i - 1];

      final int diff = (l2 - l1).abs();
      if ((l2 > l1) != increased || diff <= 0 || diff > 3) return false;
    }
    return true;
  }
}
