import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day15().solve();

class Day15 extends AdventDay {
  Day15() : super(2023, 15, name: 'Lens Library');

  @override
  dynamic part1(String input) {
    ASCIIParser asciiParser = ASCIIParser(input);
    return asciiParser.solvePart1();
  }

  @override
  dynamic part2(String input) {
    ASCIIParser asciiParser = ASCIIParser(input);
    return asciiParser.solvePart2();
  }
}

class ASCIIParser {
  final List<String> steps;

  ASCIIParser(String input) : steps = input.split(',');

  int getHash(String input) {
    int sum = 0;
    for (final c in input.chars) {
      sum = (sum + c.codeUnitAt(0)) * 17 % 256;
    }
    return sum;
  }

  int solvePart1() => steps.map((e) => getHash(e)).sum;

  int solvePart2() {
    final List<List<(String, int)>> boxes = List.generate(256, (index) => []);
    for (final step in steps) {
      final String label = RegExp(r'^(\w+)[-|=]').firstMatch(step)!.group(1)!;
      final int i = getHash(label);

      if (step.contains('=')) {
        final int focal = int.parse(step.chars.last);
        final int index = boxes[i].indexWhere((e) => e.$1 == label);
        index == -1
            ? boxes[i].add((label, focal))
            : boxes[i][index] = (label, focal);
      } else if (step.contains('-')) {
        boxes[i].removeWhere((e) => e.$1 == label);
      }
    }

    return boxes.mapIndexed((i1, e) {
      return e.mapIndexed((i2, e) => (i1 + 1) * (i2 + 1) * e.$2).sum;
    }).sum;
  }
}
