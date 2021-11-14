import 'package:elf_play/data/data_providers/settings_data_provider.dart';
import 'package:elf_play/data/models/api_response/settings_page_data.dart';
import 'package:elf_play/data/models/enums/setting_enums/app_currency.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';

class SettingDataRepository {
  //INIT PROVIDER FOR API CALL
  final SettingsDataProvider settingsDataProvider;

  const SettingDataRepository({required this.settingsDataProvider});

  Future<SettingsPageData> getSettingsPageData() async {
    final DownloadSongQuality downloadSongQuality;
    final AppCurrency preferredCurrency;
    final Map<String, dynamic> notificationTags;
    final bool isDataSaverTurnedOn;

    notificationTags = await settingsDataProvider.getNotificationTags();

    downloadSongQuality = settingsDataProvider.getDownloadSongQuality();

    isDataSaverTurnedOn = settingsDataProvider.isDataSaverTurnedOn();

    preferredCurrency = settingsDataProvider.getPreferredCurrency();

    return SettingsPageData(
      downloadSongQuality: downloadSongQuality,
      notificationTags: notificationTags,
      isDataSaverTurnedOn: isDataSaverTurnedOn,
      preferredCurrency: preferredCurrency,
    );
  }

  Future<void> changeSongDownloadQuality(
      DownloadSongQuality downloadSongQuality) async {
    await settingsDataProvider.changeSongDownloadQuality(downloadSongQuality);
  }

  DownloadSongQuality getDownloadQuality() {
    return settingsDataProvider.getDownloadSongQuality();
  }

  changeDataSaverStatus() {
    settingsDataProvider.changeDataSaverStatus();
  }

  changePreferredCurrency() {
    settingsDataProvider.changePreferredCurrency();
  }
}
