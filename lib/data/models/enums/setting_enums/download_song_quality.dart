import 'package:hive/hive.dart';

part 'download_song_quality.g.dart';

@HiveType(typeId: 12)
enum DownloadSongQuality {
  @HiveField(0)
  LOW_QUALITY,
  @HiveField(1)
  MEDIUM_QUALITY,
  @HiveField(2)
  HIGH_QUALITY,
}
