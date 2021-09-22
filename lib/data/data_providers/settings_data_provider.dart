import 'dart:async';

import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';

class SettingsDataProvider {
  //GET DATA FOR SETTINGS PAGE FROM HIVE
  Future<DownloadSongQuality> getDownloadSongQuality() async {
    ///DOWNLOAD SONG QUALITY
    DownloadSongQuality downloadSongQuality =
        await AppHiveBoxes.instance.settingsBox.get(
      AppValues.downloadSongQualityKey,
    );

    return downloadSongQuality;
  }

  Future<void> changeSongDownloadQuality(
      DownloadSongQuality downloadSongQuality) async {
    await AppHiveBoxes.instance.settingsBox
        .put(AppValues.downloadSongQualityKey, downloadSongQuality);
  }
}
