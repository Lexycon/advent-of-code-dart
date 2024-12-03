import 'package:advent_of_code_dart/src/day.dart';
import 'package:collection/collection.dart';

main() => Day03().solve();

class Day03 extends AdventDay {
  Day03() : super(2024, 3, name: 'Mull It Over');

  @override
  dynamic part1(String input) {
    final Program program = Program();
    return program.solve(input);
  }

  @override
  dynamic part2(String input) {
    final Program program = Program();

    // Remove everything between don't() and do().
    RegExp regExp = RegExp('don\'t\\(\\)(.*?)do\\(\\)', dotAll: true);
    input = input.replaceAll(regExp, '');
    return program.solve(input);
  }
}

class Program {
  int solve(String input) {
    final re = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');

    return (re.allMatches(input).map((e) {
      final int left = int.parse(e.group(1)!);
      final int right = int.parse(e.group(2)!);
      return left * right;
    }).sum);
  }
}
