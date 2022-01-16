import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/recently_purchased_items_repository.dart';

part 'recently_purchased_items_event.dart';
part 'recently_purchased_items_state.dart';

class RecentlyPurchasedItemsBloc
    extends Bloc<RecentlyPurchasedItemsEvent, RecentlyPurchasedItemsState> {
  RecentlyPurchasedItemsBloc({required this.recentlyPurchasedItemsRepository})
      : super(RecentlyPurchasedItemsInitial());

  final RecentlyPurchasedItemsRepository recentlyPurchasedItemsRepository;

  @override
  Stream<RecentlyPurchasedItemsState> mapEventToState(
      RecentlyPurchasedItemsEvent event) async* {
    if (event is SaveRecentlyPurchasedItemEvent) {
      if (event.appPurchasedItemType == AppPurchasedItemType.SONG_PAYMENT) {
        await recentlyPurchasedItemsRepository
            .saveRecentlyPurchasedSong(event.item as Song);
        yield RecentlyPurchasedSongSavedState(
          song: event.item as Song,
        );
      }
    }

    if (event is SaveRecentlyPurchasedItemEvent) {
      if (event.appPurchasedItemType == AppPurchasedItemType.ALBUM_PAYMENT) {
        await recentlyPurchasedItemsRepository
            .saveRecentlyPurchasedAlbum(event.item as Album);
        yield RecentlyPurchasedAlbumSavedState(
          album: event.item as Album,
        );
      }
    }

    if (event is SaveRecentlyPurchasedItemEvent) {
      if (event.appPurchasedItemType == AppPurchasedItemType.PLAYLIST_PAYMENT) {
        await recentlyPurchasedItemsRepository
            .saveRecentlyPurchasedPlaylist(event.item as Playlist);
        yield RecentlyPurchasedPlaylistSavedState(
          playlist: event.item as Playlist,
        );
      }
    }
  }
}
