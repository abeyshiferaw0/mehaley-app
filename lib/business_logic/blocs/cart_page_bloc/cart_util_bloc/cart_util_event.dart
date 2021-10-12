part of 'cart_util_bloc.dart';

abstract class CartUtilEvent extends Equatable {
  const CartUtilEvent();
}

class RemoveSongFromCartEvent extends CartUtilEvent {
  RemoveSongFromCartEvent({required this.song});

  final Song song;

  @override
  List<Object?> get props => [song];
}

class RemoveAlbumFromCartEvent extends CartUtilEvent {
  RemoveAlbumFromCartEvent({required this.album});

  final Album album;

  @override
  List<Object?> get props => [album];
}

class RemovePlaylistFromCartEvent extends CartUtilEvent {
  RemovePlaylistFromCartEvent({required this.playlist});

  final Playlist playlist;

  @override
  List<Object?> get props => [playlist];
}

class ClearAllCartEvent extends CartUtilEvent {
  ClearAllCartEvent();

  @override
  List<Object?> get props => [];
}
