import 'dart:ui';

import 'package:elf_play/data/models/text_lan.dart';
import 'package:flutter/cupertino.dart';

class L10nUtil {
  static final supportedLocales = [
    const Locale('en'),
    const Locale('am'),
  ];

  static final amharic = Locale('am');
  static final english = Locale('en');

  static translateLocale(TextLan textLan, BuildContext? context,
      {Locale? mCurrentLocale}) {
    Locale currentLocale;
    if (context == null) {
      if (mCurrentLocale == null)
        throw 'locale can not be null if context is null';
      currentLocale = mCurrentLocale;
    } else {
      currentLocale = Localizations.localeOf(context);
    }

    if (currentLocale.languageCode == amharic.languageCode) {
      return textLan.textAm;
    } else if (currentLocale.languageCode == english.languageCode) {
      return textLan.textEn;
    } else {
      throw 'L10nUtil file locale doesn\'t exist';
    }
  }

  static bool getCurrentLocale() {
    return false;
  }
}
