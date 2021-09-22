part of 'favorite_songs_bloc.dart';

abstract class FavoriteSongsEvent extends Equatable {
  const FavoriteSongsEvent();
}

class LoadFavoriteSongsEvent extends FavoriteSongsEvent {
  @override
  List<Object?> get props => [];
}
