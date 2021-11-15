import 'package:mehaley/data/models/playlist.dart';

class FollowedPlaylist {
  final int logId;
  final Playlist playlist;
  final DateTime created;

  FollowedPlaylist({
    required this.logId,
    required this.playlist,
    required this.created,
  });

  factory FollowedPlaylist.fromMap(Map<String, dynamic> map) {
    return FollowedPlaylist(
      logId: map["log_id"],
      playlist: Playlist.fromMap(map["playlist"]),
      created: DateTime.parse(map["created"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "log_id": this.logId,
      "playlist": this.playlist,
      "created": this.created.toIso8601String(),
    };
  }
}
