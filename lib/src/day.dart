import 'dart:io';

abstract class AdventDay {
  AdventDay(this.year, this.day, {this.name});

  final int year;
  final int day;
  final String? name;

  dynamic part1(String input);

  dynamic part2(String input);

  void part(int partNum) {
    final inputText = input();
    final start = DateTime.now();
    final answer = partNum == 1 ? part1(inputText) : part2(inputText);
    final time = DateTime.now().difference(start).inMilliseconds;

    final results = _results(answer, time);
    print('  part $partNum: $results');
  }

  void solve() {
    print('$year Day $day: ${name ?? ''}\n');
    part(1);
    part(2);
    print('');
  }

  String input() => File(_inputFileName).readAsStringSync().trimRight();

  static final inputRepoBase = '../../../input';

  String get _inputFileName =>
      '$inputRepoBase/$year/${day.toString().padLeft(2, '0')}_input.txt';

  String _results(dynamic answer, int time) {
    if (answer == null) {
      return 'not yet implemented';
    }
    return '${_format(answer)}, ($time ms)';
  }

  String _format(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
    }
    return value.toString();
  }
}
