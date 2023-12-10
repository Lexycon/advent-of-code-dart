import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day05().solve();

class Day05 extends AdventDay {
  Day05() : super(2023, 5, name: 'If You Give A Seed A Fertilizer');

  @override
  dynamic part1(String input) {
    final Almanac almanac = Almanac(input);
    return almanac.lowestLocationNumber();
  }

  @override
  dynamic part2(String input) {
    final Almanac almanac = Almanac(input);
    return almanac.lowestLocationNumberBySeedRange();
  }
}

class Almanac {
  late final List<int> seeds;
  late final List<AlmanacMap> maps;

  Almanac(String input) {
    seeds = RegExp(r'(\d+)').allIntMatches(input.lines.first);

    maps = input.split('\n\n').skip(1).map((text) {
      return AlmanacMap(RegExp(r'(\d+)').allIntMatches(text).slices(3));
    }).toList();
  }

  int lowestLocationNumber() {
    return seeds.map((seed) => _calcLocationNumber(seed)).min;
  }

  int lowestLocationNumberBySeedRange() {
    return seeds.slices(2).map((seedPair) {
      int value = _calcLocationNumber(seedPair.first);
      for (int i = seedPair.first; i < seedPair.first + seedPair.last; i++) {
        int locNumber = _calcLocationNumber(i);
        if (locNumber < value) value = locNumber;
      }
      return value;
    }).min;
  }

  int _calcLocationNumber(int seed) {
    int value = seed;
    for (int i = 0; i < maps.length; i++) {
      value = maps[i].getDestination(value);
    }
    return value;
  }
}

class AlmanacMap {
  late final List<AlmanacEntry> entries;

  AlmanacMap(Iterable<List<int>> entries) {
    this.entries = entries.map((e) => AlmanacEntry(e)).toList();
  }

  int getDestination(int value) =>
      entries.firstWhereOrNull((e) => e.isInRange(value))?.map(value) ?? value;
}

class AlmanacEntry {
  final List<int> _data;

  AlmanacEntry(this._data);

  bool isInRange(int value) {
    return (value >= _source && value <= (_source + _range));
  }

  int map(int value) {
    return _dest + (value - _source);
  }

  int get _dest => _data.first;
  int get _source => _data[1];
  int get _range => _data.last;
}
