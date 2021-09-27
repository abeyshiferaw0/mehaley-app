part of 'my_playlist_bloc.dart';

abstract class MyPlaylistEvent extends Equatable {
  const MyPlaylistEvent();
}

class LoadAllMyPlaylistsEvent extends MyPlaylistEvent {
  final bool isForAddSongPage;

  LoadAllMyPlaylistsEvent({required this.isForAddSongPage});

  @override
  List<Object?> get props => [isForAddSongPage];
}

class RefreshMyPlaylistEvent extends MyPlaylistEvent {
  final bool isForAddSongPage;
  final DateTime now;

  RefreshMyPlaylistEvent({required this.now, required this.isForAddSongPage});

  @override
  List<Object?> get props => [isForAddSongPage, now];
}
