import 'package:elf_play/data/models/enums/setting_enums/app_currency.dart';
import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:equatable/equatable.dart';

class SettingsPageData extends Equatable {
  final DownloadSongQuality downloadSongQuality;
  final AppCurrency preferredCurrency;
  final Map<String, dynamic> notificationTags;
  final bool isDataSaverTurnedOn;

  SettingsPageData({
    required this.preferredCurrency,
    required this.notificationTags,
    required this.downloadSongQuality,
    required this.isDataSaverTurnedOn,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        downloadSongQuality,
        notificationTags,
        isDataSaverTurnedOn,
        preferredCurrency
      ];
}
