import 'package:mehaley/data/models/song.dart';

class FavoriteSong {
  final int logId;
  final Song song;
  final DateTime created;

  FavoriteSong({
    required this.logId,
    required this.song,
    required this.created,
  });

  factory FavoriteSong.fromMap(Map<String, dynamic> map) {
    return FavoriteSong(
      logId: map['log_id'],
      song: Song.fromMap(map['song']),
      created: DateTime.parse(map['created']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'log_id': this.logId,
      'song': this.song,
      'created': this.created.toIso8601String(),
    };
  }
}
