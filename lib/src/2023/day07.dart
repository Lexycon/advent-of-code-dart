import 'package:advent_of_code_dart/src/day.dart';
import 'package:advent_of_code_dart/src/utils/string.dart';
import 'package:collection/collection.dart';

main() => Day07().solve();

class Day07 extends AdventDay {
  Day07() : super(2023, 7, name: 'Camel Cards');

  @override
  dynamic part1(String input) {
    final CamelCards camelCards = CamelCards(input);
    return camelCards.totalWinnings(withJoker: false);
  }

  @override
  dynamic part2(String input) {
    final CamelCards camelCards = CamelCards(input);
    return camelCards.totalWinnings(withJoker: true);
  }
}

class CamelCards {
  late final List<CamelCardsHand> hands;

  CamelCards(String input) {
    hands = RegExp(r'(\w+) (\d+)').allMatches(input).map((m) {
      final cards = m.group(1)!;
      final bid = int.parse(m.group(2)!);
      return CamelCardsHand(cards, bid);
    }).toList();
  }

  int totalWinnings({required bool withJoker}) {
    for (final hand in hands) {
      hand.calcValue(withJoker);
    }

    hands.sort((a, b) => a.value.compareTo(b.value));
    return hands.mapIndexed((i, h) => (i + 1) * h.bid).sum;
  }
}

class CamelCardsHand {
  String cards;
  final int bid;
  late int value;
  late bool withJoker;

  CamelCardsHand(this.cards, this.bid);

  void calcValue(bool withJoker) {
    this.withJoker = withJoker;

    final typeValue = <Function>[
      () => _isNPair(1),
      () => _isNPair(2),
      () => _isNOfAKind(3),
      () => _isFullHouse(),
      () => _isNOfAKind(4),
      () => _isNOfAKind(5),
    ].mapIndexed((i, e) => e() ? i + 1 : 0).max.toString();
    value = int.parse(typeValue + cardStrength);
  }

  String get cardStrength {
    final strength = withJoker ? 'J23456789TQKA' : '23456789TJQKA';
    return cards.chars.map((c) {
      return strength.indexOf(c).toString().padLeft(2, '0');
    }).join();
  }

  bool _isNOfAKind(int n) {
    for (final c in cards.chars) {
      if (_rpl(c).length == cards.length - n) return true;
    }
    return false;
  }

  bool _isFullHouse() {
    for (final c in cards.chars) {
      if (_rpl(c).chars.toSet().length == 1) return true;
    }
    return false;
  }

  bool _isNPair(int n) {
    for (final c in cards.chars) {
      if (_rpl(c).chars.toSet().length == cards.length - 1 - n) {
        return true;
      }
    }
    return false;
  }

  String _rpl(String c) {
    final replace = cards.replaceAll(c, '');
    return withJoker ? replace.replaceAll('J', '') : replace;
  }
}
