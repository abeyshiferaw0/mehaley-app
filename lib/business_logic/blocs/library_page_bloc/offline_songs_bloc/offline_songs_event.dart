part of 'offline_songs_bloc.dart';

abstract class OfflineSongsEvent extends Equatable {
  const OfflineSongsEvent();
}

class LoadOfflineSongsEvent extends OfflineSongsEvent {
  final AppLibrarySortTypes appLibrarySortTypes;

  LoadOfflineSongsEvent({required this.appLibrarySortTypes});

  @override
  List<Object?> get props => [appLibrarySortTypes];
}

class RefreshOfflineSongsEvent extends OfflineSongsEvent {
  final AppLibrarySortTypes appLibrarySortTypes;

  RefreshOfflineSongsEvent({required this.appLibrarySortTypes});

  @override
  List<Object?> get props => [appLibrarySortTypes];
}
