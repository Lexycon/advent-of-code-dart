import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/math.dart';
import 'package:collection/collection.dart';

main() => Day20().solve();

class Day20 extends AdventDay {
  Day20() : super(2023, 20, name: 'Pulse Propagation');

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
  late final List<Module> modules = [];

  System(String input) {
    final Map<String, List<String>> outputs = {};

    for (final row in input.split('\n')) {
      final m = RegExp(r'(%|&|)(\w+) -> (.+)').firstMatch(row)!;
      final (name, prefix) = (m.group(2)!, m.group(1)!);
      modules.add(Module(name, prefix));
      outputs[name] = m.group(3)!.replaceAll(' ', '').split(',');
    }

    // Add untyped modules as well.
    for (final output in outputs.values) {
      modules.addAll(output.where((e) {
        return modules.firstWhereOrNull((m) => m.name == e) == null;
      }).map((e) => Module(e)));
    }

    // Link outputs and inputs for each module.
    for (final module in modules) {
      final output = outputs[module.name];
      if (output == null) continue;

      module.outputs.addAll(output.map((e) {
        return modules.where((m) => m.name == e);
      }).flattened);

      for (final destination in module.outputs) {
        destination.inputs[module] = false;
      }
    }
  }

  int solvePart1() {
    final List<int> result = _solve(false);
    return result.reduce((v, e) => v * e);
  }

  int solvePart2() {
    List<Module> interestModules = [];
    var rxOutputModules = modules.where((e) {
      return e.outputs.map((e) => e.name).contains('rx');
    });

    for (final rxOutputModule in rxOutputModules) {
      interestModules.addAll(modules.where((e) {
        return e.outputs.contains(rxOutputModule);
      }));
    }
    return _solve(true, interestModules).reduce((v, e) => lcm(e, v));
  }

  List<int> _solve(bool isPart2, [List<Module> interestModules = const []]) {
    List<int> result = isPart2 ? [] : [-1, 0]; // lp, hp or iterations (part2)

    int steps = 0;
    while (true) {
      steps++;

      final broadcaster = modules.firstWhere((e) => e.isBroadcast);
      final List<(Module, bool, Module)> queue = [
        ...broadcaster.outputs.map((e) => (broadcaster, false, e))
      ];

      while (queue.isNotEmpty) {
        final (Module inModule, bool pulse, outModule) = queue.removeAt(0);

        if (!isPart2) {
          result[pulse ? 1 : 0]++;
          if (steps == 1001) return result..[0] += steps - 1; // Add steps too.
        } else if (isPart2 && !pulse && interestModules.contains(outModule)) {
          result.add(steps);
          if (result.length == interestModules.length) return result;
        }

        // print('${inModule.name} -$pulse-> ${outModule.name}');
        final next = outModule.process(inModule, pulse);
        queue.addAll(next);
      }
    }
  }
}

class Module {
  final String name;
  final String prefix;
  final List<Module> outputs = [];
  final Map<Module, bool> inputs = {};

  bool state = false;

  Module(this.name, [this.prefix = '']);

  List<(Module, bool, Module)> process(Module inModule, bool pulse) {
    switch (prefix) {
      case '%':
        if (!pulse) {
          state = !state;
          return _send(state);
        }

      case '&':
        inputs[inModule] = pulse;
        final nextPulse = !(inputs.values.every((e) => e == true));
        return _send(nextPulse);
    }
    if (isBroadcast) return _send(pulse);
    return [];
  }

  List<(Module, bool, Module)> _send(bool pulse) {
    return outputs.map((e) => (this, pulse, e)).toList();
  }

  bool get isBroadcast => name == 'broadcaster';
}
