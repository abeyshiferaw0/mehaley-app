import 'package:mehaley/data/models/album.dart';

class FavoriteAlbum {
  final int logId;
  final Album album;
  final DateTime created;

  FavoriteAlbum({
    required this.logId,
    required this.album,
    required this.created,
  });

  factory FavoriteAlbum.fromMap(Map<String, dynamic> map) {
    return FavoriteAlbum(
      logId: map["log_id"],
      album: Album.fromMap(map["album"]),
      created: DateTime.parse(map["created"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "log_id": this.logId,
      "song": this.album,
      "created": this.created.toIso8601String(),
    };
  }
}
