import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';
import 'package:mehaley/util/api_util.dart';

class SyncProvider {
  late Dio dio;

  void saveSyncData(
      SongSync songSync, Duration currentDuration, Duration previousDuration) {
    ///STORE SONG SYNC DATA IF NOT FOUND AND UPDATE IF FOUND
    if (AppHiveBoxes.instance.songSyncBox.containsKey(songSync.uuid)) {
      SongSync preSongSync =
          AppHiveBoxes.instance.songSyncBox.get(songSync.uuid);
      int seconds =
          preSongSync.secondsPlayed == null ? 0 : preSongSync.secondsPlayed!;
      seconds =
          seconds + (currentDuration.inSeconds - previousDuration.inSeconds);
      AppHiveBoxes.instance.songSyncBox.put(
        songSync.uuid,
        songSync.copyWith(secondsPlayed: seconds),
      );
      print(
          "SYNCEDDD DATEE= > ${songSync.uuid} CURRENT - PREVIOUS=> ${currentDuration.inSeconds - previousDuration.inSeconds} PREVIOUSLY SAVED SECONDS=> ${seconds}");
    } else {
      AppHiveBoxes.instance.songSyncBox.put(songSync.uuid, songSync);
    }
  }

  syncSongs(List<SongSync> songSyncList) async {
    dio = await AppDio.getDio();

    ///FORM DATA
    FormData formData = FormData();

    for (SongSync songSync in songSyncList) {
      formData.fields.addAll(
        [
          MapEntry(
            "sync[]",
            songSync.toMapWithQuation().toString(),
          )
        ],
      );
    }

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/add_bulk_listen_history/",
      data: formData,
      useToken: true,
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
