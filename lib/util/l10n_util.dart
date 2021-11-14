import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/enums/app_languages.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';

class L10nUtil {
  static translateLocale(TextLan textLan, BuildContext? context) {
    AppLanguage currentLocale = getCurrentLocale();

    if (currentLocale == AppLanguage.AMHARIC) {
      return textLan.textAm;
    } else if (currentLocale == AppLanguage.ENGLISH) {
      return textLan.textEn;
    } else if (currentLocale == AppLanguage.OROMIFA) {
      return textLan.textOro;
    } else {
      throw '${EnumToString.convertToString(currentLocale)} LANGUAGE NOT SUPPORTED';
    }
  }

  static AppLanguage getCurrentLocale() {
    return AppHiveBoxes.instance.settingsBox.get(AppValues.appLanguageKey);
  }

  static AppLanguage changeLocale(AppLanguage appLanguage) {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.appLanguageKey,
      appLanguage,
    );
    return AppHiveBoxes.instance.settingsBox.get(AppValues.appLanguageKey);
  }
}
