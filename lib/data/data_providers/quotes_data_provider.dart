import 'dart:math';

import 'package:elf_play/config/app_verses_list.dart';
import 'package:elf_play/data/verse.dart';
import 'package:flutter/material.dart';

class QuotesDataProvider {
  AppVersesList appVersesList = AppVersesList();
  List<Verse> getRandomVerses(int limit, Locale locale) {
    final random = new Random();
    List<Verse> versesList = [];
    if (locale.languageCode == 'am') {
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
