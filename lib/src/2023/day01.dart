import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day01().solve();

class Day01 extends AdventDay {
  Day01() : super(2023, 1, name: 'Trebuchet?!');

  @override
  dynamic part1(String input) => input.lines.map(calibrationValue).sum;

  @override
  dynamic part2(String input) => input.lines.map(spelledCalibrationValue).sum;

  int calibrationValue(String line) {
    final RegExp re = RegExp(r'(\d)');

    final Iterable<String> digits = re.allStringMatches(line);
    return int.parse('${digits.first}${digits.last}');
  }

  int spelledCalibrationValue(String line) {
    const List<String> spDigits = [
      'zero',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
    ];
    final RegExp re = RegExp('(\\d|${spDigits.join('|')}})');

    final Iterable<String> matches = re.allOverlappingStringMatches(line);
    final Iterable<String> digits = matches.map(
      (d) => spDigits.fold(d, (p, e) {
        return p.replaceAll(e, '${spDigits.indexOf(e)}');
      }),
    );
    return int.parse("${digits.first}${digits.last}");
  }
}
