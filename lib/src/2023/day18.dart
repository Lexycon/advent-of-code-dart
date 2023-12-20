import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/math.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:advent_of_code_dart/src/utils/vec2.dart';

main() => Day18().solve();

class Day18 extends AdventDay {
  Day18() : super(2023, 18, name: 'Lavaduct Lagoon');

  @override
  dynamic part1(String input) {
    DigPlan plan = DigPlan(input, useColor: false);
    return plan.solve();
  }

  @override
  dynamic part2(String input) {
    DigPlan plan = DigPlan(input, useColor: true);
    return plan.solve();
  }
}

class DigPlan {
  late List<DigStep> steps = [];

  DigPlan(String input, {required bool useColor}) {
    final List<String> rows = input.split('\n').toList();
    final RegExp re = RegExp(r'(\w) (\d+) \(#(\w{6})\)');
    for (int i = 0; i < rows.length; i++) {
      final matches = re.firstMatch(rows[i])!;
      if (useColor) {
        final color = matches.group(3)!;
        final count = int.parse(color.substring(0, 5), radix: 16);
        steps.add(DigStep(_getDir(color.chars.last), count));
      } else {
        final count = int.parse(matches.group(2)!);
        steps.add(DigStep(_getDir(matches.group(1)!), count));
      }
    }
  }

  Vec2 _getDir(String dir) {
    return switch (dir) {
      'R' || '0' => Vec2.right,
      'D' || '1' => Vec2.down,
      'L' || '2' => Vec2.left,
      'U' || '3' => Vec2.up,
      _ => Vec2.zero,
    };
  }

  int solve() {
    List<Vec2> pts = [Vec2.zero];
    for (final (step) in steps) {
      pts.add(pts.last + step.dir * step.count);
    }
    return shoelaceArea(pts);
  }
}

class DigStep {
  final Vec2 dir;
  final int count;

  DigStep(this.dir, this.count);
}
