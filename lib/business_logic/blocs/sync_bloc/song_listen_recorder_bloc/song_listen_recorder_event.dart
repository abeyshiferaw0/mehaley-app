part of 'song_listen_recorder_bloc.dart';

abstract class SongListenRecorderEvent extends Equatable {}

class StartRecordEvent extends SongListenRecorderEvent {
  @override
  List<Object?> get props => [];
}

class SaveRecordedSongEvent extends SongListenRecorderEvent {
  final SongSync songSync;
  final Duration? previousDuration;
  final Duration? skipToDuration;

  SaveRecordedSongEvent({this.previousDuration, this.skipToDuration, required this.songSync});

  @override
  List<Object?> get props => [songSync,previousDuration,skipToDuration];
}
