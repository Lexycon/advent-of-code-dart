import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';

main() => Day13().solve();

class Day13 extends AdventDay {
  Day13() : super(2023, 13, name: 'Point of Incidence');

  @override
  dynamic part1(String input) {
    Reflection reflection = Reflection(input, 0);
    return reflection.solve();
  }

  @override
  dynamic part2(String input) {
    Reflection reflection = Reflection(input, 1);
    return reflection.solve();
  }
}

class Reflection {
  final List<Pattern> patterns = [];
  final int smudgeLimit;

  Reflection(String input, this.smudgeLimit) {
    for (final data in input.split('\n\n')) {
      final List<String> rows = data.split('\n').toList();
      final List<String> columns = [];
      for (int i = 0; i < rows.first.length; i++) {
        columns.add(rows.map((e) => e.chars[i]).join());
      }
      patterns.add(Pattern(rows, columns));
    }
  }

  int solve() {
    int r = 0;
    for (final pattern in patterns) {
      final columns = _checkMirror(pattern.columns, 1);
      r += columns > 0 ? columns : _checkMirror(pattern.rows, 100);
    }
    return r;
  }

  int _checkMirror(List<String> list, int multiplier) {
    List<Candidate> candidates = [];
    for (int i = 0; i < list.length - 1; i++) {
      final candidate = Candidate(i, list[i], list[i + 1]);
      if (candidate.isValidWithSmudge(smudgeLimit)) {
        candidates.add(candidate);
      }
    }

    for (final candidate in candidates) {
      if (_isPerfectMirror(list, candidate)) {
        return (candidate.id + 1) * multiplier;
      }
    }
    return 0;
  }

  bool _isPerfectMirror(List<String> list, Candidate candidate) {
    int smug = candidate.smudge;

    for (int i = candidate.id - 1; i >= 0; i--) {
      int i2 = candidate.id + (candidate.id - i) + 1;
      if (i < 0 || i2 >= list.length) break;

      final nextCandidate = Candidate(i, list[i], list[i2]);
      if (!nextCandidate.isValidWithSmudge(smudgeLimit)) return false;
      smug += nextCandidate.smudge;
      if (smug > smudgeLimit) return false;
    }

    return smug == smudgeLimit;
  }
}

class Pattern {
  final List<String> rows;
  final List<String> columns;

  Pattern(this.rows, this.columns);
}

class Candidate {
  final int id;
  late final List<String> l1;
  late final List<String> l2;
  int smudge = 0;

  Candidate(this.id, String s1, String s2) {
    l1 = s1.chars;
    l2 = s2.chars;
  }

  bool isValidWithSmudge(int smudgeLimit) {
    for (int i = 0; i < l1.length; i++) {
      if (l1[i] != l2[i]) {
        smudge++;
        if (smudge > smudgeLimit) return false;
      }
    }
    return true;
  }
}
