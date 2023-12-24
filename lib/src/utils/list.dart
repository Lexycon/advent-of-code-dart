extension ListExtension on List<int> {
  List<int> repeat(int n) {
    List<int> newList = [];
    for (int i = 0; i < n; i++) {
      newList.addAll(this);
    }
    return newList;
  }

  bool listContainsAll<T>(List<T> a, List<T> b) {
    final setA = Set.of(a);
    return setA.containsAll(b);
  }
}
