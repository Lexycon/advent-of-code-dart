import 'dart:math';

import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day04().solve();

class Day04 extends AdventDay {
  Day04() : super(2023, 4, name: 'Scratchcards');

  @override
  dynamic part1(String input) {
    final Game game = Game(input);
    return game.scratchCards.map((e) => e.calcPoints()).sum;
  }

  @override
  dynamic part2(String input) {
    final Game game = Game(input);
    return game.calcTotalCards();
  }
}

class Game {
  late final List<ScratchCard> scratchCards;

  Game(String input) {
    scratchCards = input.lines.map((line) {
      final RegExp re = RegExp(r'(\d+)');
      final firstNrs = re.allIntMatches(line.split('|').first);
      final lastNrs = re.allIntMatches(line.split('|').last);

      return ScratchCard(firstNrs.first, firstNrs.sublist(1), lastNrs);
    }).toList();
  }

  int calcTotalCards() {
    return scratchCards.map((card) => _calcTotalCardsRecursive(card)).sum;
  }

  int _calcTotalCardsRecursive(ScratchCard card) {
    if (card.matches == 0) return 1;
    final wonCards = scratchCards.where(
      (c) => c.id >= card.id + 1 && c.id <= (card.id + card.matches),
    );
    return wonCards.map((e) => _calcTotalCardsRecursive(e)).sum + 1;
  }
}

class ScratchCard {
  final int id;
  final List<int> winningNrs;
  final List<int> haveNrs;
  late final int matches;

  ScratchCard(this.id, this.winningNrs, this.haveNrs) {
    matches = haveNrs.map((e) => winningNrs.contains(e) ? 1 : 0).sum;
  }

  int calcPoints() {
    return matches == 0 ? 0 : pow(2, matches - 1).toInt();
  }
}
