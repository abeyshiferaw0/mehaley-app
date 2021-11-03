part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerState extends Equatable {}

class AudioPlayerInitialState extends AudioPlayerState {
  @override
  List<Object?> get props => [];
}

class AudioPlayerErrorState extends AudioPlayerState {
  final String error;
  final String msg;

  AudioPlayerErrorState({required this.msg, required this.error});

  @override
  List<Object?> get props => [msg, error];
}

class AudioPlayerCurrentSongChangeState extends AudioPlayerState {
  final Song song;

  AudioPlayerCurrentSongChangeState({required this.song});

  @override
  List<Object?> get props => [song];
}

class AudioPlayerStateChangedState extends AudioPlayerState {
  final PlayerState playerState;

  AudioPlayerStateChangedState({required this.playerState});

  @override
  List<Object?> get props => [playerState];
}

class AudioPlayerPlayPauseStateChangedState extends AudioPlayerState {
  final bool isPlaying;

  AudioPlayerPlayPauseStateChangedState({required this.isPlaying});

  @override
  List<Object?> get props => [isPlaying];
}

class AudioPlayerShuffleChangedState extends AudioPlayerState {
  final bool isEnabled;

  AudioPlayerShuffleChangedState({required this.isEnabled});

  @override
  List<Object?> get props => [isEnabled];
}

class AudioPlayerLoopChangedState extends AudioPlayerState {
  final LoopMode loopMode;

  AudioPlayerLoopChangedState({required this.loopMode});

  @override
  List<Object?> get props => [loopMode];
}

class AudioPlayerPositionChangedState extends AudioPlayerState {
  final Duration duration;

  AudioPlayerPositionChangedState({
    required this.duration,
  });

  @override
  List<Object?> get props => [duration];
}

class AudioPlayerBufferedPositionChangedState extends AudioPlayerState {
  final Duration duration;

  AudioPlayerBufferedPositionChangedState({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class AudioPlayerDurationChangedState extends AudioPlayerState {
  final Duration duration;

  AudioPlayerDurationChangedState({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class AudioPlayerVideoModeChangedState extends AudioPlayerState {
  final bool enabled;

  AudioPlayerVideoModeChangedState({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class AudioPlayerQueueChangedState extends AudioPlayerState {
  final List<Song> queue;
  final int currentIndex;

  AudioPlayerQueueChangedState(
      {required this.queue, required this.currentIndex});

  @override
  List<Object?> get props => [queue, currentIndex];
}

class AudioPlayerVolumeChangedState extends AudioPlayerState {
  final double volume;

  AudioPlayerVolumeChangedState({required this.volume});

  @override
  List<Object?> get props => [volume];
}

class AudioPlayerSkipChangedState extends AudioPlayerState {
  final Duration skipToDuration;

  AudioPlayerSkipChangedState({required  this.skipToDuration});

  @override
  List<Object?> get props => [skipToDuration];
}
