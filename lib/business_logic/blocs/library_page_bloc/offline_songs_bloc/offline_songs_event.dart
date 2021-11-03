part of 'offline_songs_bloc.dart';

abstract class OfflineSongsEvent extends Equatable {
  const OfflineSongsEvent();
}

class LoadOfflineSongsEvent extends OfflineSongsEvent {
  final AppLibrarySortTypes appLibrarySortTypes;
  final Locale currentLocale;

  LoadOfflineSongsEvent(
      {required this.appLibrarySortTypes, required this.currentLocale});

  @override
  List<Object?> get props => [appLibrarySortTypes, currentLocale];
}

class RefreshOfflineSongsEvent extends OfflineSongsEvent {
  final AppLibrarySortTypes appLibrarySortTypes;
  final Locale currentLocale;

  RefreshOfflineSongsEvent(
      {required this.appLibrarySortTypes, required this.currentLocale});

  @override
  List<Object?> get props => [appLibrarySortTypes, currentLocale];
}
