import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';

part 'song_sync.g.dart';

@HiveType(typeId: 17)
class SongSync {
  @HiveField(0)
  final String? uuid;
  @HiveField(1)
  final SongSyncPlayedFrom playedFrom;
  @HiveField(2)
  final int? playedFromId;
  @HiveField(3)
  final bool isPreview;
  @HiveField(4)
  final DateTime listenDate;
  @HiveField(5)
  final double? secondsPlayed;
  SongSync({
    required this.uuid,
    required this.playedFrom,
    required this.playedFromId,
    required this.isPreview,
    required this.listenDate,
    required this.secondsPlayed,
  });

  factory SongSync.fromMap(Map<String, dynamic> json) {
    return SongSync(
      uuid: json["uuid"],
      playedFrom: EnumToString.fromString(
          SongSyncPlayedFrom.values, json["playedFrom"])!,
      playedFromId: json["playedFromId"],
      isPreview: json["isPreview"],
      listenDate: DateTime.parse(json["listenDate"]),
      secondsPlayed: json["secondsPlayed"] != null
          ? double.parse(json["secondsPlayed"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uuid": this.uuid,
      "playedFrom": EnumToString.convertToString(this.playedFrom),
      "playedFromId": this.playedFromId,
      "isPreview": this.isPreview,
      "listenDate": this.listenDate.toIso8601String(),
      "secondsPlayed": this.secondsPlayed,
    };
  }
}
