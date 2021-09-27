part of 'favorite_albums_bloc.dart';

abstract class FavoriteAlbumsEvent extends Equatable {
  const FavoriteAlbumsEvent();
}

class LoadFavoriteAlbumsEvent extends FavoriteAlbumsEvent {
  @override
  List<Object?> get props => [];
}

class RefreshFavoriteAlbumsEvent extends FavoriteAlbumsEvent {
  @override
  List<Object?> get props => [];
}
