part of 'cart_util_bloc.dart';

abstract class CartUtilEvent extends Equatable {
  const CartUtilEvent();
}

class ClearAllCartEvent extends CartUtilEvent {
  ClearAllCartEvent();

  @override
  List<Object?> get props => [];
}

///FOR ADDING AND REMOVING TO CART
class AddRemovedSongCartEvent extends CartUtilEvent {
  AddRemovedSongCartEvent({required this.song, required this.appCartAddRemoveEvents});

  final Song song;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  @override
  List<Object?> get props => [song, appCartAddRemoveEvents];
}

class AddRemoveAlbumCartEvent extends CartUtilEvent {
  AddRemoveAlbumCartEvent({required this.appCartAddRemoveEvents, required this.album});

  final Album album;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  @override
  List<Object?> get props => [album, appCartAddRemoveEvents];
}

class AddRemovePlaylistCartEvent extends CartUtilEvent {
  AddRemovePlaylistCartEvent({required this.appCartAddRemoveEvents, required this.playlist});

  final Playlist playlist;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  @override
  List<Object?> get props => [playlist, appCartAddRemoveEvents];
}
