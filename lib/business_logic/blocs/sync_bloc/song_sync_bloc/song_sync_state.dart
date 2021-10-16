part of 'song_sync_bloc.dart';

abstract class SongSyncState extends Equatable {
  const SongSyncState();
}

class SongSyncInitial extends SongSyncState {
  @override
  List<Object> get props => [];
}

class SongSyncingStartedEvent extends SongSyncState {
  @override
  List<Object?> get props => [];
}

class SyncingState extends SongSyncState {
  @override
  List<Object?> get props => [];
}

class SyncingSuccessState extends SongSyncState {
  @override
  List<Object?> get props => [];
}

class SyncingErrorState extends SongSyncState {
  final String error;

  SyncingErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}
