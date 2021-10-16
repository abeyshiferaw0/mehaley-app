part of 'song_listen_recorder_bloc.dart';

abstract class SongListenRecorderState extends Equatable {}

class SongListenRecorderInitial extends SongListenRecorderState {
  @override
  List<Object?> get props => [];
}

class SongRecordingStartedState extends SongListenRecorderState {
  @override
  List<Object?> get props => [];
}

class RecordedSongSavingState extends SongListenRecorderState {
  final SongSync songSync;

  RecordedSongSavingState({required this.songSync});

  @override
  List<Object?> get props => [songSync];
}

class RecordedSongSuccessState extends SongListenRecorderState {
  final SongSync songSync;

  RecordedSongSuccessState({required this.songSync});

  @override
  List<Object?> get props => [songSync];
}

class RecordedSongErrorState extends SongListenRecorderState {
  final String error;

  RecordedSongErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
