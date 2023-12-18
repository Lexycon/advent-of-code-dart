import 'package:advent_of_code_dart/src/utils/string.dart';

Iterable<Iterable<T>> combinations<T>(Iterable<T> elements, int length) sync* {
  if (elements.isEmpty && length != 0) {
    return;
  } else if (length == 0) {
    yield <T>[];
  } else {
    final T element = elements.first;
    for (final Iterable<T> subset
        in combinations<T>(elements.skip(1), length - 1)) {
      yield <T>[element, ...subset];
    }
    for (final Iterable<T> subset
        in combinations<T>(elements.skip(1), length)) {
      yield subset;
    }
  }
}

class NDigitNumber {
  late final List<int> digits;
  final int _base;

  NDigitNumber(int digits, this._base) {
    this.digits = List.generate(digits, (i) => 0);
  }

  bool increment() {
    for (var pos = 0; pos < digits.length; pos++) {
      if (++digits[pos] < _base) break;
      if (pos == digits.length - 1) return false;
      for (var i = 0; i <= pos; i++) {
        digits[i] = 0;
      }
    }
    return true;
  }
}

Iterable<String> permutations(
  String input,
  String placeholder,
  List<String> replacements,
) {
  List<int> placeholderPositions = [];
  for (var i = 0; i < input.length; i++) {
    if (input[i] == placeholder) {
      placeholderPositions.add(i);
    }
  }

  final List<String> results = [];
  var number = NDigitNumber(placeholderPositions.length, replacements.length);
  while (true) {
    final result = input.chars;
    for (var i = 0; i < placeholderPositions.length; i++) {
      result[placeholderPositions[i]] = replacements[number.digits[i]];
    }
    results.add(result.join());

    if (!number.increment()) break;
  }
  return results;
}
