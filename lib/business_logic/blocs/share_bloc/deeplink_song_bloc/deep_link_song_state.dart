part of 'deep_link_song_bloc.dart';

abstract class DeepLinkSongState extends Equatable {
  const DeepLinkSongState();
}

class DeepLinkSongInitial extends DeepLinkSongState {
  @override
  List<Object> get props => [];
}


class DeepLinkSongLoading extends DeepLinkSongState {
  @override
  List<Object> get props => [];
}


class DeepLinkSongLoadingError extends DeepLinkSongState {
  final String error;

  DeepLinkSongLoadingError({required this.error});
  @override
  List<Object> get props => [error];
}


class DeepLinkSongLoaded extends DeepLinkSongState {
  final Song song;

  DeepLinkSongLoaded({required this.song});

  @override
  List<Object> get props => [song];
}
