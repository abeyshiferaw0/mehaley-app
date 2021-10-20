part of 'lyric_bloc.dart';

abstract class LyricEvent extends Equatable {
  const LyricEvent();
}

class LoadSongLyricEvent extends LyricEvent {
  final int songId;
  final Locale currentLocale;

  LoadSongLyricEvent({required this.currentLocale, required this.songId});

  @override
  List<Object?> get props => [songId, currentLocale];
}

class RemoveLyricWidgetEvent extends LyricEvent {
  final int songId;

  RemoveLyricWidgetEvent({required this.songId});

  @override
  List<Object?> get props => [songId];
}
