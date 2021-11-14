import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/data/models/api_response/settings_page_data.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:elf_play/data/repositories/setting_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'settings_page_event.dart';
part 'settings_page_state.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  SettingsPageBloc({required this.settingDataRepository})
      : super(SettingsPageInitial());

  final SettingDataRepository settingDataRepository;

  @override
  Stream<SettingsPageState> mapEventToState(
    SettingsPageEvent event,
  ) async* {
    if (event is LoadSettingsDataEvent) {
      yield SettingPageLoadingState();
      SettingsPageData settingsPageData =
          await settingDataRepository.getSettingsPageData();
      yield SettingPageLoadedState(settingsPageData: settingsPageData);
    } else if (event is ChangeSongDownloadQualityEvent) {
      yield SettingPageLoadingState();
      settingDataRepository
          .changeSongDownloadQuality(event.downloadSongQuality);
      SettingsPageData settingsPageData =
          await settingDataRepository.getSettingsPageData();
      yield SettingPageLoadedState(settingsPageData: settingsPageData);
    } else if (event is ChangeDataSaverStatusEvent) {
      yield SettingPageLoadingState();
      await settingDataRepository.changeDataSaverStatus();
      SettingsPageData settingsPageData =
          await settingDataRepository.getSettingsPageData();
      yield SettingPageLoadedState(settingsPageData: settingsPageData);
    } else if (event is ChangePreferredCurrencyEvent) {
      yield SettingPageLoadingState();
      settingDataRepository.changePreferredCurrency();
      SettingsPageData settingsPageData =
          await settingDataRepository.getSettingsPageData();
      yield SettingPageLoadedState(settingsPageData: settingsPageData);
    }
  }
}
