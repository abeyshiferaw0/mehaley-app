import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/text_lan.dart';

class L10nUtil {
  static translateLocale(TextLan textLan, BuildContext? context) {
    AppLanguage currentLocale = getCurrentLocale();

    if (currentLocale == AppLanguage.AMHARIC) {
      return textLan.textAm;
    } else if (currentLocale == AppLanguage.ENGLISH) {
      return textLan.textEn;
    } else if (currentLocale == AppLanguage.OROMIFA) {
      return textLan.textOro;
    } else if (currentLocale == AppLanguage.TIGRINYA) {
      return textLan.textTig;
    } else {
      throw '${EnumToString.convertToString(currentLocale)} LANGUAGE NOT SUPPORTED';
    }
  }

  static AppLanguage getCurrentLocale() {
    return AppHiveBoxes.instance.settingsBox.get(AppValues.appLanguageKey);
  }

  static Future<AppLanguage> changeLocale(AppLanguage appLanguage) async {
    await AppHiveBoxes.instance.settingsBox.put(
      AppValues.appLanguageKey,
      appLanguage,
    );
    return AppHiveBoxes.instance.settingsBox.get(AppValues.appLanguageKey);
  }
}
