import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/math.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';

main() => Day08().solve();

class Day08 extends AdventDay {
  Day08() : super(2023, 8, name: 'Haunted Wasteland');

  @override
  dynamic part1(String input) {
    final Network network = Network(input);
    return network.solve();
  }

  @override
  dynamic part2(String input) {
    final Network network = Network(input);
    return network.solveSimultaneously();
  }
}

class Network {
  late final List<String> lrInstructions;
  late final Map<String, (String, String)> network;

  Network(String input) {
    lrInstructions = input.lines.first.chars;

    final RegExp re = RegExp(r'(\w{3}) = \((\w{3}), (\w{3})\)');
    network = Map.fromEntries(re.allMatches(input).map((m) {
      return MapEntry(m.group(1)!, (m.group(2)!, m.group(3)!));
    }));
  }

  int solve() => _navigate('AAA', 'ZZZ');

  int solveSimultaneously() => _navigate('A', 'Z');

  int _navigate(String sPattern, String ePattern) {
    final startNodes = network.keys.where((k) => k.endsWith(sPattern));
    bool isEndNodeFn(String e) => e.endsWith(ePattern);

    return startNodes.map((startNode) {
      return getSteps(startNode, isEndNodeFn);
    }).reduce(lcm);
  }

  int getSteps(String node, bool Function(String) isEndNodeFn) {
    int steps = 0;

    while (!isEndNodeFn(node)) {
      final direction = lrInstructions[steps++ % lrInstructions.length];
      final entry = network[node]!;
      node = direction == 'L' ? entry.$1 : entry.$2;
    }
    return steps;
  }
}
