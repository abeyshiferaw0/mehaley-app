part of 'library_bloc.dart';

@immutable
abstract class LibraryState extends Equatable {}

class LibraryInitial extends LibraryState {
  @override
  List<Object?> get props => [];
}

///SONG LIKE UNLIKE
class SongLikeUnlikeLoadingState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class SongLikeUnlikeSuccessState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  SongLikeUnlikeSuccessState({
    required this.id,
    required this.appLikeFollowEvents,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class SongLikeUnlikeErrorState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  SongLikeUnlikeErrorState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

///ALBUM LIKE UNLIKE
class AlbumLikeUnlikeLoadingState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class AlbumLikeUnlikeSuccessState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  AlbumLikeUnlikeSuccessState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class AlbumLikeUnlikeErrorState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  AlbumLikeUnlikeErrorState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

///PLAYLIST FOLLOW UNFOLLOW
class PlaylistFollowUnFollowLoadingState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class PlaylistFollowUnFollowSuccessState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  PlaylistFollowUnFollowSuccessState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class PlaylistFollowUnFollowErrorState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  PlaylistFollowUnFollowErrorState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

///ARTIST FOLLOW UNFOLLOW
class ArtistFollowUnFollowLoadingState extends LibraryState {
  @override
  List<Object?> get props => [];
}

class ArtistFollowUnFollowSuccessState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  ArtistFollowUnFollowSuccessState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class ArtistFollowUnFollowErrorState extends LibraryState {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  ArtistFollowUnFollowErrorState({
    required this.appLikeFollowEvents,
    required this.id,
  });

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}
