import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/combinatorics.dart';
import 'package:advent_of_code_dart/src/utils/list.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:memoized/memoized.dart';

main() => Day12().solve();

class Day12 extends AdventDay {
  Day12() : super(2023, 12, name: 'Hot Springs');

  @override
  dynamic part1(String input) {
    Records records = Records(input);
    return records.getPossibleArrangements();
  }

  @override
  dynamic part2(String input) {
    Records records = Records(input);
    return records.getPossibleArrangementsWithUnfold();
  }
}

class Records {
  late final List<Entry> rows;

  Records(String input) {
    final lines = input.split('\n').toList();
    rows = lines.map((r) {
      final data = r.split(' ');
      final damages = RegExp(r'(\d+)').allIntMatches(data.last);
      return Entry(data.first, damages);
    }).toList();
  }

  int _solveBruteforce(String record, List<int> damages) {
    final reSprings = damages.map((e) => '#{$e}').join(r'\.+');
    final re = RegExp(r'^\.*' + reSprings + r'\.*$');
    final records = permutations(record, '?', ['.', '#']);
    return records.where((e) => re.firstMatch(e) != null).length;
  }

  int _solveRecursiveMemo(Entry entry) {
    late final Memoized1<int, Entry> fn;
    fn = Memoized1((Entry row) {
      final String record = row.record;
      final List<int> damages = row.damages;

      if (damages.isEmpty) return record.contains('#') ? 0 : 1;
      if (record.isEmpty) return 0;

      int r = 0;
      final String nextchar = record.chars.first;
      final int nextDmg = damages.first;

      switch (nextchar) {
        case '#':
          if (!RegExp('^[\\#\\?]{$nextDmg}').hasMatch(record)) break;
          if (row.damages.length > 1) {
            if (!_isValidNextSpring(record, nextDmg)) return 0;
            r += fn(Entry(record.substring(nextDmg + 1), damages.sublist(1)));
          } else {
            r += fn(Entry(record.substring(nextDmg), damages.sublist(1)));
          }
        case '.':
          r += fn(Entry(record.substring(1), damages));
        case '?':
          r += fn(Entry(record.replaceFirst('?', '#'), damages)) +
              fn(Entry(record.replaceFirst('?', '.'), damages));
      }
      return r;
    }, capacity: 400);

    return fn(entry);
  }

  bool _isValidNextSpring(String record, int damage) =>
      !((record.length < (damage + 1)) || record.chars[damage] == '#');

  int getPossibleArrangements() {
    // * Part 1 is slow :)
    // return rows.map((e) => _solveBruteforce(e.record, e.damages)).sum;
    return rows.map((e) => _solveRecursiveMemo(e)).sum;
  }

  int getPossibleArrangementsWithUnfold() {
    final rows = this.rows.map((r) {
      String record = (('${r.record}?') * 5);
      record = record.substring(0, record.length - 1);
      return Entry(record, r.damages.repeat(5));
    });
    return rows.map((e) => _solveRecursiveMemo(e)).sum;
  }
}

class Entry extends Equatable {
  final String record;
  final List<int> damages;

  Entry(this.record, this.damages);

  @override
  List<Object?> get props => [record + damages.toString()];
}
