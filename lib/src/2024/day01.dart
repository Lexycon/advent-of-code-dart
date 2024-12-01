import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day01().solve();

class Day01 extends AdventDay {
  Day01() : super(2024, 1, name: 'Historian Hysteria');

  @override
  dynamic part1(String input) {
    final Locations data = Locations(input);
    return data.calcDistanceSum();
  }

  @override
  dynamic part2(String input) {
    final Locations data = Locations(input);
    return data.calcSimilarityScore();
  }
}

class Locations {
  final List<int> leftList = [];
  final List<int> rightList = [];

  Locations(String input) {
    for (String line in input.split('\n')) {
      final re = RegExp(r'(\d+)');
      final numbers = re.allIntMatches(line).toList();
      leftList.add(numbers[0]);
      rightList.add(numbers[1]);
    }

    leftList.sort();
    rightList.sort();
  }

  int calcDistanceSum() {
    return leftList.mapIndexed((i, e) => (rightList[i] - e).abs()).sum;
  }

  int calcSimilarityScore() {
    return leftList.map((l) => l * rightList.where((r) => r == l).length).sum;
  }
}
