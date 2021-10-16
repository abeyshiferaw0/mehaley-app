import 'package:dio/dio.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/sync/song_sync.dart';
import 'package:elf_play/util/api_util.dart';

class SyncProvider {
  late Dio dio;

  void saveSyncData(SongSync songSync) {
    ///STORE SONG SYNC DATA IF NOT FOUND AND UPDATE IF FOUND
    AppHiveBoxes.instance.songSyncBox.put(songSync.uuid, songSync);
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

    formData.fields.forEach((element) {
      print("MAPENTERY=>>> ${element}");
    });

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
