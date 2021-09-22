import 'package:elf_play/data/models/artist.dart';

class FollowedArtist {
  final int logId;
  final Artist artist;
  final DateTime created;

  FollowedArtist({
    required this.logId,
    required this.artist,
    required this.created,
  });

  factory FollowedArtist.fromMap(Map<String, dynamic> map) {
    return FollowedArtist(
      logId: map["log_id"],
      artist: Artist.fromMap(map["artist"]),
      created: DateTime.parse(map["created"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "log_id": this.logId,
      "artist": this.artist,
      "created": this.created.toIso8601String(),
    };
  }
}
