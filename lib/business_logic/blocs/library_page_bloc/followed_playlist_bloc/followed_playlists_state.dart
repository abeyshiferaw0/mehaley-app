part of 'followed_playlists_bloc.dart';

abstract class FollowedPlaylistsState extends Equatable {
  const FollowedPlaylistsState();
}

class FollowedPlaylistInitial extends FollowedPlaylistsState {
  @override
  List<Object> get props => [];
}

class FollowedPlaylistsLoadedState extends FollowedPlaylistsState {
  final List<FollowedPlaylist> followedPlaylists;

  FollowedPlaylistsLoadedState({required this.followedPlaylists});

  @override
  List<Object?> get props => [followedPlaylists];
}

class FollowedPlaylistsLoadingErrorState extends FollowedPlaylistsState {
  final String error;

  FollowedPlaylistsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FollowedPlaylistsLoadingState extends FollowedPlaylistsState {
  @override
  List<Object?> get props => [];
}
