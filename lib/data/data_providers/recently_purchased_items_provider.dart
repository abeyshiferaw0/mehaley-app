import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class RecentlyPurchasedItemsProvider {
  late Dio dio;

  Future<void> saveRecentlyPurchasedSong(Song song) async {
    await AppHiveBoxes.instance.recentlyPurchasedSong.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      song.copyWith(isBought: true).toMap(),
    );
  }

  saveRecentlyPurchasedAlbum(Album album) async {
    await AppHiveBoxes.instance.recentlyPurchasedAlbum.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      album.copyWith(isBought: true).toMap(),
    );
  }

  saveRecentlyPurchasedPlaylist(Playlist playlist) async {
    await AppHiveBoxes.instance.recentlyPurchasedPlaylist.put(
      DateTime.now().millisecondsSinceEpoch.toString(),
      playlist.copyWith(isBought: true).toMap(),
    );
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
