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

// ///FOR REMOVING FROM CART
// class CartUtilSongRemovedState extends CartUtilState {
//   final Song song;
//
//   CartUtilSongRemovedState({required this.song});
//
//   @override
//   List<Object?> get props => [song];
// }
//
// class CartUtilAlbumRemovedState extends CartUtilState {
//   final Album album;
//
//   CartUtilAlbumRemovedState({required this.album});
//
//   @override
//   List<Object?> get props => [album];
// }
//
// class CartUtilPlaylistRemovedState extends CartUtilState {
//   final Playlist playlist;
//
//   CartUtilPlaylistRemovedState({required this.playlist});
//
//   @override
//   List<Object?> get props => [playlist];
// }
//
//
// class CartUtilSongRemoveErrorState extends CartUtilState {
//   final String error;
//   final Song song;
//
//   CartUtilSongRemoveErrorState({required this.song, required this.error});
//
//   @override
//   List<Object?> get props => [error, song];
// }
//
// class CartUtilAlbumRemoveErrorState extends CartUtilState {
//   final String error;
//   final Album album;
//
//   CartUtilAlbumRemoveErrorState({required this.error, required this.album});
//
//   @override
//   List<Object?> get props => [error, album];
// }
//
// class CartUtilPlaylistRemoveErrorState extends CartUtilState {
//   final String error;
//   final Playlist playlist;
//
//   CartUtilPlaylistRemoveErrorState({required this.error, required this.playlist});
//
//   @override
//   List<Object?> get props => [error, playlist];
// }

///FOR ADDING TO CART
///SONG
class CartUtilSongAddingState extends CartUtilState {
  final Song song;

  CartUtilSongAddingState({required this.song});

  @override
  List<Object?> get props => [song];
}

class CartUtilSongAddedSuccessState extends CartUtilState {
  final Song song;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  CartUtilSongAddedSuccessState({required this.song, required this.appCartAddRemoveEvents});

  @override
  List<Object?> get props => [song, appCartAddRemoveEvents];
}

class CartUtilSongAddingErrorState extends CartUtilState {
  final Song song;
  final String error;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  CartUtilSongAddingErrorState({required this.error, required this.song, required this.appCartAddRemoveEvents});

  @override
  List<Object?> get props => [song, error, appCartAddRemoveEvents];
}

///ALBUM
class CartUtilAlbumAddingState extends CartUtilState {
  final Album album;

  CartUtilAlbumAddingState({required this.album});

  @override
  List<Object?> get props => [album];
}

class CartUtilAlbumAddedSuccessState extends CartUtilState {
  final Album album;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  CartUtilAlbumAddedSuccessState({required this.album, required this.appCartAddRemoveEvents});

  @override
  List<Object?> get props => [album, appCartAddRemoveEvents];
}

class CartUtilAlbumAddingErrorState extends CartUtilState {
  final Album album;
  final String error;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  CartUtilAlbumAddingErrorState({required this.error, required this.album, required this.appCartAddRemoveEvents});

  @override
  List<Object?> get props => [album, error, appCartAddRemoveEvents];
}

///PLAYLIST
class CartUtilPlaylistAddingState extends CartUtilState {
  final Playlist playlist;

  CartUtilPlaylistAddingState({required this.playlist});

  @override
  List<Object?> get props => [playlist];
}

class CartUtilPlaylistAddedSuccessState extends CartUtilState {
  final Playlist playlist;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  CartUtilPlaylistAddedSuccessState({required this.playlist, required this.appCartAddRemoveEvents});

  @override
  List<Object?> get props => [playlist, appCartAddRemoveEvents];
}

class CartUtilPlaylistAddingErrorState extends CartUtilState {
  final Playlist playlist;
  final String error;
  final AppCartAddRemoveEvents appCartAddRemoveEvents;

  CartUtilPlaylistAddingErrorState({required this.error, required this.playlist, required this.appCartAddRemoveEvents});

  @override
  List<Object?> get props => [playlist, error, appCartAddRemoveEvents];
}
