part of 'settings_page_bloc.dart';

abstract class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();
}

class LoadSettingsDataEvent extends SettingsPageEvent {
  @override
  List<Object?> get props => [];
}

class LoadSettingsDataForFirstTimeDialogEvent extends SettingsPageEvent {
  @override
  List<Object?> get props => [];
}

class ChangeSongDownloadQualityEvent extends SettingsPageEvent {
  final DownloadSongQuality downloadSongQuality;

  ChangeSongDownloadQualityEvent({required this.downloadSongQuality});

  @override
  List<Object?> get props => [downloadSongQuality];
}

class ChangeDataSaverStatusEvent extends SettingsPageEvent {
  ChangeDataSaverStatusEvent();

  @override
  List<Object?> get props => [];
}

class ChangePreferredCurrencyEvent extends SettingsPageEvent {
  ChangePreferredCurrencyEvent();

  @override
  List<Object?> get props => [];
}
