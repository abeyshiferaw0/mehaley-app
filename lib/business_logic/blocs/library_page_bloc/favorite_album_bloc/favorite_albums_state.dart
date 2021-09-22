part of 'favorite_albums_bloc.dart';

abstract class FavoriteAlbumsState extends Equatable {
  const FavoriteAlbumsState();
}

class FavoriteAlbumsInitial extends FavoriteAlbumsState {
  @override
  List<Object> get props => [];
}

class FavoriteAlbumsLoadedState extends FavoriteAlbumsState {
  final List<FavoriteAlbum> favoriteAlbums;

  FavoriteAlbumsLoadedState({required this.favoriteAlbums});

  @override
  List<Object?> get props => [favoriteAlbums];
}

class FavoriteAlbumsLoadingErrorState extends FavoriteAlbumsState {
  final String error;

  FavoriteAlbumsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FavoriteAlbumsLoadingState extends FavoriteAlbumsState {
  @override
  List<Object?> get props => [];
}
