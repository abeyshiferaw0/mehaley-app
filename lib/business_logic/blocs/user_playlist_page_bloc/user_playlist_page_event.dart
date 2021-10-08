part of 'user_playlist_page_bloc.dart';

@immutable
abstract class UserPlaylistPageEvent extends Equatable {}

class LoadUserPlaylistPageEvent extends UserPlaylistPageEvent {
  final int playlistId;

  LoadUserPlaylistPageEvent({required this.playlistId});

  @override
  List<Object?> get props => [playlistId];
}

class RefreshUserPlaylistPageEvent extends UserPlaylistPageEvent {
  final MyPlaylist myPlaylist;
  final List<Song> songs;

  RefreshUserPlaylistPageEvent({
    required this.songs,
    required this.myPlaylist,
  });

  @override
  List<Object?> get props => [myPlaylist, songs];
}

class SongRemovedFromPlaylistEvent extends UserPlaylistPageEvent {
  final Song song;
  final int playlistId;

  SongRemovedFromPlaylistEvent({
    required this.playlistId,
    required this.song,
  });

  @override
  List<Object?> get props => [song, playlistId];
}
