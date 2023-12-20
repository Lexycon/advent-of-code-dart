import 'package:advent_of_code_dart/src/day.dart';
import 'package:collection/collection.dart';

main() => Day19().solve();

class Day19 extends AdventDay {
  Day19() : super(2023, 19, name: 'Aplenty');

  @override
  dynamic part1(String input) {
    System system = System(input);
    return system.solvePart1();
  }

  @override
  dynamic part2(String input) {
    System system = System(input);
    return system.solvePart2();
  }
}

class System {
  late final Map<String, Workflow> workflows = {};
  final List<Map<String, int>> parts = [];

  System(String input) {
    List<String> split = input.split('\n\n');
    for (final row in split.first.split('\n')) {
      final m = RegExp(r'(\w+)\{(.+)\}').firstMatch(row)!;
      workflows[m.group(1)!] = Workflow(m.group(2)!.split(','));
    }

    for (final row in split.last.split('\n')) {
      final matches = RegExp(r'(\w)=(\d+)').allMatches(row).toList();
      parts.add(Map.fromEntries(matches.map((e) {
        return MapEntry(e.group(1)!, int.parse(e.group(2)!));
      })));
    }
  }

  int solvePart1() {
    int sum = 0;
    for (final Map<String, int> part in parts) {
      String currentWorkflow = 'in';
      while (!'AR'.contains(currentWorkflow)) {
        currentWorkflow = workflows[currentWorkflow]!.process(part);
      }
      if (currentWorkflow == 'A') sum += part.values.sum;
    }
    return sum;
  }

  int solvePart2() {
    const (int, int) r = (1, 4000);
    final Map<String, (int, int)> part = {'x': r, 'm': r, 'a': r, 's': r};
    final List<Map<String, (int, int)>> parts = [];

    final List<(String, Map<String, (int, int)>)> nodes = [('in', part)];

    while (nodes.isNotEmpty) {
      final (String, Map<String, (int, int)>) node = nodes.removeAt(0);
      final List<Rule> rules = workflows[node.$1]!.rules;
      final Map<String, (int, int)> part = node.$2;

      for (final Rule rule in rules) {
        final Map<String, (int, int)> cpPart = {...part}; // Copy.

        switch (rule.op) {
          case '<':
            cpPart[rule.category] = (cpPart[rule.category]!.$1, rule.value - 1);
            part[rule.category] = (rule.value, part[rule.category]!.$2);
          case '>':
            cpPart[rule.category] = (rule.value + 1, cpPart[rule.category]!.$2);
            part[rule.category] = (part[rule.category]!.$1, rule.value);
        }

        if ('AR'.contains(rule.nextWorkflow)) {
          if (rule.nextWorkflow == 'A') parts.add(cpPart);
        } else {
          nodes.add((rule.nextWorkflow, cpPart));
        }
      }
    }

    return parts.map((e) {
      return e.values.map((e) => e.$2 - e.$1 + 1).reduce((v, e) => v * e);
    }).sum;
  }
}

class Workflow {
  late final List<Rule> rules;

  Workflow(List<String> input) {
    rules = input.map((e) {
      final m = RegExp(r'(\w)(.)(\d+):(.+)').firstMatch(e);
      if (m == null) return Rule.noCondition(e);
      final int value = int.parse(m.group(3)!);
      return Rule(m.group(1)!, m.group(2)!, value, m.group(4)!);
    }).toList();
  }

  String process(Map<String, int> part) {
    for (Rule rule in rules) {
      switch (rule.op) {
        case '<':
          if (part[rule.category]! < rule.value) return rule.nextWorkflow;
        case '>':
          if (part[rule.category]! > rule.value) return rule.nextWorkflow;
      }
    }
    return rules.last.nextWorkflow;
  }
}

class Rule {
  final String category;
  final String op;
  final int value;
  final String nextWorkflow;

  const Rule(this.category, this.op, this.value, this.nextWorkflow);
  const Rule.noCondition(this.nextWorkflow)
      : category = '',
        op = '',
        value = 0;
}
