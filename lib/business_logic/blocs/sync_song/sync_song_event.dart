part of 'sync_song_bloc.dart';

abstract class SyncSongEvent extends Equatable {}

class DumSongEvent extends SyncSongEvent {
  @override
  List<Object?> get props => [];
}
