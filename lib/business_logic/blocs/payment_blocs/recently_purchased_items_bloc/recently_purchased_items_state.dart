part of 'recently_purchased_items_bloc.dart';

abstract class RecentlyPurchasedItemsState extends Equatable {
  const RecentlyPurchasedItemsState();
}

class RecentlyPurchasedItemsInitial extends RecentlyPurchasedItemsState {
  @override
  List<Object> get props => [];
}

class RecentlyPurchasedSongSavedState extends RecentlyPurchasedItemsState {
  final Song song;

  RecentlyPurchasedSongSavedState({required this.song});
  @override
  List<Object> get props => [song];
}

class RecentlyPurchasedAlbumSavedState extends RecentlyPurchasedItemsState {
  final Album album;

  RecentlyPurchasedAlbumSavedState({required this.album});
  @override
  List<Object> get props => [album];
}

class RecentlyPurchasedPlaylistSavedState extends RecentlyPurchasedItemsState {
  final Playlist playlist;

  RecentlyPurchasedPlaylistSavedState({required this.playlist});
  @override
  List<Object> get props => [playlist];
}
