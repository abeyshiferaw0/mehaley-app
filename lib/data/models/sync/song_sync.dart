import 'package:enum_to_string/enum_to_string.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';

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
  final bool isPurchased;
  @HiveField(5)
  final bool isOffline;
  @HiveField(6)
  final String listenDate;
  @HiveField(7)
  final int? secondsPlayed;
  @HiveField(8)
  final int songId;
  @HiveField(9)
  final bool isUserSubscribed;
  SongSync({
    required this.songId,
    required this.uuid,
    required this.playedFrom,
    required this.playedFromId,
    required this.isPreview,
    required this.isPurchased,
    required this.isOffline,
    required this.listenDate,
    required this.secondsPlayed,
    required this.isUserSubscribed,
  });

  factory SongSync.fromMap(Map<String, dynamic> json) {
    return SongSync(
      songId: json["song_id"],
      uuid: json["listen_sync_id"],
      playedFrom: EnumToString.fromString(
          SongSyncPlayedFrom.values, json["played_from"])!,
      playedFromId: json["played_from_id"],
      isPreview: json["is_preview"],
      isPurchased: json["is_purchased"],
      isOffline: json["is_offline"],
      listenDate: json["listen_date"],
      secondsPlayed:
          json["s_played"] != null ? int.parse(json["s_played"]) : null,
      isUserSubscribed: json["is_user_subscribed"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "song_id": this.songId,
      "listen_sync_id": this.uuid,
      "played_from": EnumToString.convertToString(this.playedFrom),
      "played_from_id": this.playedFromId,
      "is_preview": this.isPreview,
      "is_purchased": this.isPurchased,
      "is_offline": this.isOffline,
      "listen_date": this.listenDate,
      "s_played": this.secondsPlayed,
      "is_user_subscribed": this.isUserSubscribed,
    };
  }

  Map<String, dynamic> toMapWithQuation() {
    if (this.playedFromId == -1) {
      return {
        "\"song_id\"": this.songId,
        "\"listen_sync_id\"": "\"${this.uuid}\"",
        "\"played_from\"":
            "\"${EnumToString.convertToString(this.playedFrom)}\"",
        "\"is_preview\"": this.isPreview ? 1 : 0,
        "\"is_purchased\"": this.isPurchased ? 1 : 0,
        "\"is_offline\"": this.isOffline ? 1 : 0,
        "\"listen_date\"": "\"${this.listenDate}\"",
        "\"s_played\"": this.secondsPlayed,
        "\"is_user_subscribed\"": this.isUserSubscribed ? 1 : 0,
      };
    }
    return {
      "\"song_id\"": this.songId,
      "\"listen_sync_id\"": "\"${this.uuid}\"",
      "\"played_from\"": "\"${EnumToString.convertToString(this.playedFrom)}\"",
      "\"played_from_id\"": "\"${this.playedFromId}\"",
      "\"is_preview\"": this.isPreview ? 1 : 0,
      "\"is_purchased\"": this.isPurchased ? 1 : 0,
      "\"is_offline\"": this.isOffline ? 1 : 0,
      "\"listen_date\"": "\"${this.listenDate}\"",
      "\"s_played\"": this.secondsPlayed,
      "\"is_user_subscribed\"": this.isUserSubscribed ? 1 : 0,
    };
  }

  SongSync copyWith({
    String? uuid,
    SongSyncPlayedFrom? playedFrom,
    int? playedFromId,
    bool? isPreview,
    bool? isPurchased,
    bool? isOffline,
    String? listenDate,
    int? secondsPlayed,
    int? songId,
    bool? isUserSubscribed,
  }) {
    return SongSync(
      songId: songId ?? this.songId,
      uuid: uuid ?? this.uuid,
      playedFrom: playedFrom ?? this.playedFrom,
      playedFromId: playedFromId ?? this.playedFromId,
      isPreview: isPreview ?? this.isPreview,
      isPurchased: isPreview ?? this.isPurchased,
      isOffline: isOffline ?? this.isOffline,
      listenDate: listenDate ?? this.listenDate,
      secondsPlayed: secondsPlayed ?? this.secondsPlayed,
      isUserSubscribed: isUserSubscribed ?? this.isUserSubscribed,
    );
  }
}
