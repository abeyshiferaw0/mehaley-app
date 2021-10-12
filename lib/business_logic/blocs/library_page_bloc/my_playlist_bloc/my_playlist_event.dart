part of 'my_playlist_bloc.dart';

abstract class MyPlaylistEvent extends Equatable {
  const MyPlaylistEvent();
}

class LoadAllMyPlaylistsEvent extends MyPlaylistEvent {
  final bool isForAddSongPage;
  final bool? isForUserPlaylistDeleted;
  final MyPlaylist? deletedPlaylist;

  LoadAllMyPlaylistsEvent({
    this.deletedPlaylist,
    this.isForUserPlaylistDeleted,
    required this.isForAddSongPage,
  });

  @override
  List<Object?> get props =>
      [isForAddSongPage, isForUserPlaylistDeleted, deletedPlaylist];
}

class RefreshMyPlaylistEvent extends MyPlaylistEvent {
  final bool isForAddSongPage;
  final DateTime now;

  RefreshMyPlaylistEvent({required this.now, required this.isForAddSongPage});

  @override
  List<Object?> get props => [isForAddSongPage, now];
}
