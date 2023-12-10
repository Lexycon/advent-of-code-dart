import 'package:collection/collection.dart';

extension StringExtension on String {
  List<String> get chars => split('');
  List<String> get lines => split('\n');
}

extension RegExpExtension on RegExp {
  Iterable<String> allStringMatches(String input) =>
      allMatches(input).map((m) => m.group(0).toString());

  List<int> allIntMatches(String input) =>
      allMatches(input).map((m) => int.parse('${m.group(0)}')).toList();

  Iterable<String> allOverlappingStringMatches(String input) {
    final List<String> matches = [];
    for (int i = 0; i < input.length; i++) {
      final RegExpMatch? match = allMatches(input, i).firstOrNull;
      if (match == null) break;
      matches.add(match.group(0).toString());
    }
    return matches;
  }
}
