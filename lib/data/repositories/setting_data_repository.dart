import 'package:elf_play/data/data_providers/settings_data_provider.dart';
import 'package:elf_play/data/models/api_response/settings_page_data.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';

class SettingDataRepository {
  //INIT PROVIDER FOR API CALL
  final SettingsDataProvider settingsDataProvider;

  const SettingDataRepository({required this.settingsDataProvider});

  Future<SettingsPageData> getSettingsPageData() async {
    final DownloadSongQuality downloadSongQuality;

    downloadSongQuality = await settingsDataProvider.getDownloadSongQuality();

    return SettingsPageData(downloadSongQuality: downloadSongQuality);
  }

  Future<void> changeSongDownloadQuality(
      DownloadSongQuality downloadSongQuality) async {
    await settingsDataProvider.changeSongDownloadQuality(downloadSongQuality);
  }
}
