import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';

main() => Day06().solve();

class Day06 extends AdventDay {
  Day06() : super(2023, 6, name: 'Wait For It');

  @override
  dynamic part1(String input) {
    final Game game = Game(input);
    return game.countOfWinningOptions();
  }

  @override
  dynamic part2(String input) {
    final Game game = Game(input.replaceAll(RegExp(' '), ''));
    return game.countOfWinningOptions();
  }
}

class Game {
  late final Iterable<Race> races;

  Game(String input) {
    final times = RegExp(r'(\d+)').allIntMatches(input.lines.first);
    final distances = RegExp(r'(\d+)').allIntMatches(input.lines.last);
    races = Iterable.generate(times.length).expand((i) sync* {
      yield Race(times[i], distances[i]);
    });
  }

  int countOfWinningOptions() {
    return races.map((e) => e.countOfWinningOptions()).reduce((v, e) => v * e);
  }
}

class Race {
  final int time;
  final int distance;

  Race(this.time, this.distance);

  Iterable<int> calcDistances() {
    return Iterable.generate(time, (i) => i + 1).map((e) => (time - e) * e);
  }

  int countOfWinningOptions() {
    return calcDistances().where((e) => e > distance).length;
  }
}
