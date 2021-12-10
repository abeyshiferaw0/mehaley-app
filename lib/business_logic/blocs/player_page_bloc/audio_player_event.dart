part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerEvent extends Equatable {}

class AudioPlayerStartServiceEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class SetPlayerQueueEvent extends AudioPlayerEvent {
  final List<AudioSource> queue;
  final bool startPlaying;
  final int index;

  SetPlayerQueueEvent(
      {required this.startPlaying, required this.index, required this.queue});

  @override
  List<Object?> get props => [queue];
}

class PlayerStateChangedEvent extends AudioPlayerEvent {
  final PlayerState playerState;

  PlayerStateChangedEvent({required this.playerState});

  @override
  List<Object?> get props => [playerState];
}

class ChangeCurrentSongEvent extends AudioPlayerEvent {
  final Song song;

  ChangeCurrentSongEvent({required this.song});

  @override
  List<Object?> get props => [song];
}

class ReportPlayerEvent extends AudioPlayerEvent {
  final String msg;
  final String error;

  ReportPlayerEvent({required this.msg, required this.error});

  @override
  List<Object?> get props => [msg, error];
}

class PlayPauseEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class PlayPauseChangedEvent extends AudioPlayerEvent {
  final bool isPlaying;

  PlayPauseChangedEvent({required this.isPlaying});
  @override
  List<Object?> get props => [isPlaying];
}

class PlayNextSongEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class PlayPreviousSongEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class ShufflePlayerQueueEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class ShufflePlayerOnQueueEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class LoopPlayerQueueEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}

class PlayerShuffleChangedEvent extends AudioPlayerEvent {
  final bool isEnabled;

  PlayerShuffleChangedEvent({required this.isEnabled});

  @override
  List<Object?> get props => [isEnabled];
}

class PlayerLoopChangedEvent extends AudioPlayerEvent {
  final LoopMode loopMode;

  PlayerLoopChangedEvent({required this.loopMode});

  @override
  List<Object?> get props => [loopMode];
}

class PositionChangedEvent extends AudioPlayerEvent {
  final Duration duration;

  PositionChangedEvent({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class BufferedPositionChangedEvent extends AudioPlayerEvent {
  final Duration duration;

  BufferedPositionChangedEvent({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class DurationChangedEvent extends AudioPlayerEvent {
  final Duration duration;

  DurationChangedEvent({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class SeekAudioPlayerEvent extends AudioPlayerEvent {
  final Duration skipToDuration;

  SeekAudioPlayerEvent({required this.skipToDuration});

  @override
  List<Object?> get props => [skipToDuration];
}

class SeekAudioPlayerToEvent extends AudioPlayerEvent {
  final Song song;

  SeekAudioPlayerToEvent({required this.song});

  @override
  List<Object?> get props => [song];
}

class ChangePlayerVideoMode extends AudioPlayerEvent {
  final bool enable;

  ChangePlayerVideoMode({required this.enable});

  @override
  List<Object?> get props => [enable];
}

class PlayerQueueChangedEvent extends AudioPlayerEvent {
  final List<Song> queue;
  final int currentIndex;

  PlayerQueueChangedEvent({required this.queue, required this.currentIndex});

  @override
  List<Object?> get props => [queue, currentIndex];
}

class UpdateQueueItemsMovedEvent extends AudioPlayerEvent {
  final Song oldMedia;
  final Song newMedia;

  UpdateQueueItemsMovedEvent({required this.oldMedia, required this.newMedia});

  @override
  List<Object?> get props => [oldMedia, newMedia];
}

// class UpdateQueueItemsMovedEvent extends AudioPlayerEvent {
//   final int oldIndex;
//   final int newIndex;
//
//   UpdateQueueItemsMovedEvent({required this.oldIndex, required this.newIndex});
//
//   @override
//   List<Object?> get props => [oldIndex, newIndex];
// }

class SetMutedEvent extends AudioPlayerEvent {
  SetMutedEvent();

  @override
  List<Object?> get props => [];
}

class PlayerVolumeChangedEvent extends AudioPlayerEvent {
  final double volume;

  PlayerVolumeChangedEvent({required this.volume});

  @override
  List<Object?> get props => [volume];
}

class ReloadAndPausePlayerEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}


class StopPlayerEvent extends AudioPlayerEvent {
  @override
  List<Object?> get props => [];
}
