part of 'cart_util_bloc.dart';

abstract class CartUtilState extends Equatable {
  const CartUtilState();
}

class CartUtilInitial extends CartUtilState {
  @override
  List<Object> get props => [];
}

class CartUtilLoadingState extends CartUtilState {
  @override
  List<Object?> get props => [];
}

class CartUtilSongRemovedState extends CartUtilState {
  final Song song;

  CartUtilSongRemovedState({required this.song});

  @override
  List<Object?> get props => [song];
}

class CartUtilAlbumRemovedState extends CartUtilState {
  final Album album;

  CartUtilAlbumRemovedState({required this.album});

  @override
  List<Object?> get props => [album];
}

class CartUtilPlaylistRemovedState extends CartUtilState {
  final Playlist playlist;

  CartUtilPlaylistRemovedState({required this.playlist});

  @override
  List<Object?> get props => [playlist];
}

class CartAllRemovedState extends CartUtilState {
  @override
  List<Object?> get props => [];
}

class CartAllRemovingErrorState extends CartUtilState {
  final String error;

  CartAllRemovingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class CartUtilSongRemoveErrorState extends CartUtilState {
  final String error;
  final Song song;

  CartUtilSongRemoveErrorState({required this.song, required this.error});

  @override
  List<Object?> get props => [error, song];
}

class CartUtilAlbumRemoveErrorState extends CartUtilState {
  final String error;
  final Album album;

  CartUtilAlbumRemoveErrorState({required this.error, required this.album});

  @override
  List<Object?> get props => [error, album];
}

class CartUtilPlaylistRemoveErrorState extends CartUtilState {
  final String error;
  final Playlist playlist;

  CartUtilPlaylistRemoveErrorState({required this.error, required this.playlist});

  @override
  List<Object?> get props => [error, playlist];
}
