part of 'song_sync_bloc.dart';

abstract class SongSyncEvent extends Equatable {
  const SongSyncEvent();
}

class StartSongSyncEvent extends SongSyncEvent {
  @override
  List<Object?> get props => [];
}

class SyncEvent extends SongSyncEvent {
  final int hCode;

  SyncEvent({required this.hCode});

  @override
  List<Object?> get props => [hCode];
}
