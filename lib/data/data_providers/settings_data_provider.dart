import 'dart:async';

import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SettingsDataProvider {
  //GET DATA FOR SETTINGS PAGE FROM HIVE
  DownloadSongQuality getDownloadSongQuality() {
    ///DOWNLOAD SONG QUALITY
    DownloadSongQuality downloadSongQuality =
        AppHiveBoxes.instance.settingsBox.get(
      AppValues.downloadSongQualityKey,
    );

    return downloadSongQuality;
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
}
