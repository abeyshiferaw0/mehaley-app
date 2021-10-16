import 'package:dio/dio.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/data/data_providers/sync_provider.dart';
import 'package:elf_play/data/models/sync/song_sync.dart';

class SyncRepository {
  //INIT PROVIDER FOR API CALL
  final SyncProvider syncProvider;

  const SyncRepository({required this.syncProvider});

  void saveSyncData(SongSync songSync) {
    syncProvider.saveSyncData(songSync);
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
    return response;
  }
}
