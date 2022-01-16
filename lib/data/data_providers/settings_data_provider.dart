import 'dart:async';

import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:mehaley/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SettingsDataProvider {
  //GET DATA FOR SETTINGS PAGE FROM HIVE
  DownloadSongQuality getDownloadSongQuality() {
    DownloadSongQuality downloadSongQuality =
        AppHiveBoxes.instance.settingsBox.get(
      AppValues.downloadSongQualityKey,
    );

    return downloadSongQuality;
  }

  AppCurrency getPreferredCurrency() {
    AppCurrency preferredCurrency = AppHiveBoxes.instance.settingsBox.get(
      AppValues.preferredCurrencyKey,
    );

    return preferredCurrency;
  }

  Future<void> changeSongDownloadQuality(
      DownloadSongQuality downloadSongQuality) async {
    await AppHiveBoxes.instance.settingsBox
        .put(AppValues.downloadSongQualityKey, downloadSongQuality);
  }

  Future<Map<String, dynamic>> getNotificationTags() async {
    Map<String, dynamic> map = await OneSignal.shared.getTags().catchError((e) {
      throw e.toString();
    });
    return map;
  }

  bool isDataSaverTurnedOn() {
    return AppHiveBoxes.instance.settingsBox.get(
      AppValues.isDataSaverTurnedOnKey,
    );
  }

  void changeDataSaverStatus() {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.isDataSaverTurnedOnKey,
      !this.isDataSaverTurnedOn(),
    );
  }

  void changePreferredCurrency() {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.preferredCurrencyKey,
      this.getPreferredCurrency() == AppCurrency.ETB
          ? AppCurrency.ETB
          : AppCurrency.USD,
    );
  }

  AppCurrency changePreferredCurrencyByValue(AppCurrency appCurrency) {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.preferredCurrencyKey,
      appCurrency,
    );
    AppCurrency preferredCurrency = AppHiveBoxes.instance.settingsBox.get(
      AppValues.preferredCurrencyKey,
    );

    return preferredCurrency;
  }
}
