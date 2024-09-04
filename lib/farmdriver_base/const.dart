class FarmdriverConst {
  // Days list
  static const List<int> days = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7
  ];

  // Age semaines generator
  static List<int> generateWeekAges() {
    List<int> result = [];
    for (int i = 0; i <= 1000; i++) {
      result.add(i);
    }
    return result;
  }
}
