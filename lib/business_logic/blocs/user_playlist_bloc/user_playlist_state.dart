part of 'user_playlist_bloc.dart';

abstract class UserPlaylistState extends Equatable {
  const UserPlaylistState();
}

class UserPlaylistInitial extends UserPlaylistState {
  @override
  List<Object> get props => [];
}

class UserPlaylistLoadingState extends UserPlaylistState {
  @override
  List<Object?> get props => [];
}

class UserPlaylistLoadingErrorState extends UserPlaylistState {
  final String error;

  UserPlaylistLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserPlaylistPostedState extends UserPlaylistState {
  UserPlaylistPostedState({required this.myPlaylist});

  final MyPlaylist myPlaylist;

  @override
  List<Object?> get props => [myPlaylist];
}

class UserPlaylistUpdatedState extends UserPlaylistState {
  UserPlaylistUpdatedState({required this.myPlaylist});

  final MyPlaylist myPlaylist;

  @override
  List<Object?> get props => [myPlaylist];
}

class SongAddedToPlaylistState extends UserPlaylistState {
  final MyPlaylist myPlaylist;
  final Song song;

  SongAddedToPlaylistState({required this.myPlaylist, required this.song});

  @override
  List<Object?> get props => [myPlaylist, song];
}

class SongRemovedFromPlaylistState extends UserPlaylistState {
  final MyPlaylist myPlaylist;
  final Song song;

  SongRemovedFromPlaylistState({required this.myPlaylist, required this.song});

  @override
  List<Object?> get props => [myPlaylist, song];
}
