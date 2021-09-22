part of 'followed_playlists_bloc.dart';

abstract class FollowedPlaylistEvent extends Equatable {
  const FollowedPlaylistEvent();
}

class LoadFollowedPlaylistsEvent extends FollowedPlaylistEvent {
  @override
  List<Object?> get props => [];
}
