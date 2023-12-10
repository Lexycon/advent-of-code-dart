import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day09().solve();

class Day09 extends AdventDay {
  Day09() : super(2023, 9, name: 'Mirage Maintenance');

  @override
  dynamic part1(String input) {
    final Report report = Report(input);
    return report.solve(report.extrapolateEnd);
  }

  @override
  dynamic part2(String input) {
    final Report report = Report(input);
    return report.solve(report.extrapolateBegin);
  }
}

class Report {
  late final List<List<int>> entries;

  Report(String input) {
    final RegExp re = RegExp(r'(-?\d+)');
    entries = input.split('\n').map((line) => re.allIntMatches(line)).toList();
  }

  int solve(Function(List<List<int>>) fn) {
    return entries.map((e) => _extrapolate(e, fn)).sum;
  }

  int _extrapolate(List<int> sequence, Function(List<List<int>>) fn) {
    List<List<int>> data = [sequence];
    while (!data.last.every((e) => e == 0)) {
      data.add(List.generate(
        data.last.length - 1,
        (i) => data.last[i + 1] - data.last[i],
      ));
    }
    return fn(data);
  }

  int extrapolateEnd(List<List<int>> data) {
    for (int i = data.length - 1; i > 0; i--) {
      data[i - 1].add(data[i].last + data[i - 1].last);
    }
    return data.first.last;
  }

  int extrapolateBegin(List<List<int>> data) {
    for (int i = data.length - 1; i > 0; i--) {
      data[i - 1].insert(0, data[i - 1].first - data[i].first);
    }
    return data.first.first;
  }
}
