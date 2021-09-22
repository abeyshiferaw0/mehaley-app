part of 'library_bloc.dart';

@immutable
abstract class LibraryEvent extends Equatable {}

class LikeUnlikeSongEvent extends LibraryEvent {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  LikeUnlikeSongEvent({required this.appLikeFollowEvents, required this.id});

  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class LikeUnLikeAlbumEvent extends LibraryEvent {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  LikeUnLikeAlbumEvent({required this.id, required this.appLikeFollowEvents});
  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class FollowUnFollowPlaylistEvent extends LibraryEvent {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  FollowUnFollowPlaylistEvent({
    required this.id,
    required this.appLikeFollowEvents,
  });
  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}

class FollowUnFollowArtistEvent extends LibraryEvent {
  final int id;
  final AppLikeFollowEvents appLikeFollowEvents;

  FollowUnFollowArtistEvent({
    required this.id,
    required this.appLikeFollowEvents,
  });
  @override
  List<Object?> get props => [id, appLikeFollowEvents];
}
