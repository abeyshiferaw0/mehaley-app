import 'package:mehaley/data/data_providers/recently_purchased_items_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class RecentlyPurchasedItemsRepository {
  //INIT PROVIDER FOR API CALL
  final RecentlyPurchasedItemsProvider recentlyPurchasedItemsProvider;

  const RecentlyPurchasedItemsRepository(
      {required this.recentlyPurchasedItemsProvider});

  saveRecentlyPurchasedSong(Song song) async {
    await recentlyPurchasedItemsProvider.saveRecentlyPurchasedSong(song);
  }

  saveRecentlyPurchasedAlbum(Album album) async {
    await recentlyPurchasedItemsProvider.saveRecentlyPurchasedAlbum(album);
  }

  saveRecentlyPurchasedPlaylist(Playlist playlist) async {
    await recentlyPurchasedItemsProvider
        .saveRecentlyPurchasedPlaylist(playlist);
  }

  cancelDio() {
    recentlyPurchasedItemsProvider.cancel();
  }
}
