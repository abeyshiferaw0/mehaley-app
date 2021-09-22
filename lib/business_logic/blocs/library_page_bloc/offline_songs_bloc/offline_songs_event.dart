part of 'offline_songs_bloc.dart';

abstract class OfflineSongsEvent extends Equatable {
  const OfflineSongsEvent();
}

class LoadOfflineSongsEvent extends OfflineSongsEvent {
  @override
  List<Object?> get props => [];
}
