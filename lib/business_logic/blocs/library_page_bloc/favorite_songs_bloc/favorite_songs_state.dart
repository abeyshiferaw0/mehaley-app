part of 'favorite_songs_bloc.dart';

abstract class FavoriteSongsState extends Equatable {
  const FavoriteSongsState();
}

class FavoriteSongsInitial extends FavoriteSongsState {
  @override
  List<Object> get props => [];
}

class FavoriteSongsLoadedState extends FavoriteSongsState {
  final List<FavoriteSong> favoriteSongs;

  FavoriteSongsLoadedState({required this.favoriteSongs});

  @override
  List<Object?> get props => [favoriteSongs];
}

class FavoriteSongsLoadingErrorState extends FavoriteSongsState {
  final String error;

  FavoriteSongsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FavoriteSongsLoadingState extends FavoriteSongsState {
  @override
  List<Object?> get props => [];
}
