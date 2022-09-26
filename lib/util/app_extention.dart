extension DateUtils on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}

extension PriceAmountParser on double {
  String parsePriceAmount() {
    return this.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String divideAfterThreeChar() {
    String newStr = "";
    List<String> strList = [];
    for (int i = 0; i < this.length; i++) {
      if ((i % 3 == 0) & (i > 0)) {
        strList.add(' ');
      }
      strList.add(this[i]);
    }
    newStr = strList.join();
    return newStr;
  }

  String unescape() {
    String newStr = this;
    newStr = newStr.replaceAll("&lt;", "<");
    newStr = newStr.replaceAll("&gt;", ">");
    newStr = newStr.replaceAll("&amp;", "&");
    return newStr;
  }
}

extension ExtendedVersionNumber on String {
  int getExtendedVersionNumber() {
    // Note that if you want to support bigger version cells than 99,
    // just increase the returned versionCells multipliers
    List versionCells = this.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }
}


