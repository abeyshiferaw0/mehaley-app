part of 'settings_page_bloc.dart';

abstract class SettingsPageState extends Equatable {
  const SettingsPageState();
}

class SettingsPageInitial extends SettingsPageState {
  @override
  List<Object> get props => [];
}

class SettingPageLoadingState extends SettingsPageState {
  @override
  List<Object?> get props => [];
}

class SettingPageLoadedState extends SettingsPageState {
  final SettingsPageData settingsPageData;

  SettingPageLoadedState({required this.settingsPageData});

  @override
  List<Object?> get props => [settingsPageData];
}

class SettingPageLoadingErrorState extends SettingsPageState {
  final String error;

  SettingPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
