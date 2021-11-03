import 'package:elf_play/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:equatable/equatable.dart';

class SettingsPageData extends Equatable {
  final DownloadSongQuality downloadSongQuality;
  final Map<String, dynamic> notificationTags;

  SettingsPageData(
      {required this.notificationTags, required this.downloadSongQuality});

  @override
  // TODO: implement props
  List<Object?> get props => [downloadSongQuality, notificationTags];
}
