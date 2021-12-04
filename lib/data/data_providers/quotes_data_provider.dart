import 'dart:math';

import 'package:mehaley/config/app_verses_list.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/verse.dart';
import 'package:mehaley/util/l10n_util.dart';

class QuotesDataProvider {
  AppVersesList appVersesList = AppVersesList();
  List<Verse> getRandomVerses(int limit) {
    final random = new Random();
    List<Verse> versesList = [];
    if (L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC) {
      for (var i = 0; i < limit; i++) {
        int rand = random.nextInt(appVersesList.amharicList.length);
        var verseElement = appVersesList.amharicList[rand];
        var referenceElement = appVersesList.referencesListAmharic[rand];
        versesList.add(
          Verse(
            reference: referenceElement,
            verse: verseElement,
          ),
        );
      }
    } else {
      for (var i = 0; i < limit; i++) {
        int rand = random.nextInt(appVersesList.englishList.length);
        var verseElement = appVersesList.englishList[rand];
        var referenceElement = appVersesList.referencesListEnglish[rand];
        versesList.add(
          Verse(
            reference: referenceElement,
            verse: verseElement,
          ),
        );
      }
    }
    return versesList;
  }
}
