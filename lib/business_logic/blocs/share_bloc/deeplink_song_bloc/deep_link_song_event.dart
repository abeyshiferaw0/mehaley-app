part of 'deep_link_song_bloc.dart';

abstract class DeepLinkSongEvent extends Equatable {
  const DeepLinkSongEvent();
}

class LoadDeepLinkSongEvent extends DeepLinkSongEvent {
  final int songId;

  LoadDeepLinkSongEvent({required this.songId});

  @override
  List<Object?> get props => [songId];
}
