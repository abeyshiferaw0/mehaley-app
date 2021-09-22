part of 'offline_songs_bloc.dart';

abstract class OfflineSongsState extends Equatable {
  const OfflineSongsState();
}

class OfflineSongsInitial extends OfflineSongsState {
  @override
  List<Object> get props => [];
}

class OfflineSongsLoadedState extends OfflineSongsState {
  final List<Song> offlineSongs;

  OfflineSongsLoadedState({required this.offlineSongs});

  @override
  List<Object?> get props => [offlineSongs];
}

class OfflineSongsLoadingErrorState extends OfflineSongsState {
  final String error;

  OfflineSongsLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class OfflineSongsLoadingState extends OfflineSongsState {
  @override
  List<Object?> get props => [];
}
