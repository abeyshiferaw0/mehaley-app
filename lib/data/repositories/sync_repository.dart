import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/data/data_providers/sync_provider.dart';
import 'package:mehaley/data/models/sync/song_sync.dart';

class SyncRepository {
  //INIT PROVIDER FOR API CALL
  final SyncProvider syncProvider;

  const SyncRepository({required this.syncProvider});

  void saveSyncData(
      SongSync songSync, Duration currentDuration, Duration previousDuration) {
    syncProvider.saveSyncData(songSync, currentDuration, previousDuration);
  }

  cancelDio() {
    syncProvider.cancel();
  }

  List<SongSync> getSongsToSync() {
    List<SongSync> songSyncList = [];
    AppHiveBoxes.instance.songSyncBox.values.forEach((element) {
      if (element is SongSync) {
        if (element.secondsPlayed != null) {
          if (element.secondsPlayed! > 0) {
            songSyncList.add(element);
          }
        }
      }
    });
    return songSyncList;
  }

  Future<Response> syncSongs(List<SongSync> songSyncList) async {
    Response response = await syncProvider.syncSongs(songSyncList);
    if (response.statusCode == 200) {
      AppHiveBoxes.instance.songSyncBox.deleteAll(
        songSyncList.map((e) => e.uuid),
      );
    }
    return response;
  }
}
