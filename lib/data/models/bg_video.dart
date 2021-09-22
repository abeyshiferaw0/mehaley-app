import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'bg_video.g.dart';

@HiveType(typeId: 3)
class BgVideo extends Equatable {
  @HiveField(0)
  final int songBgVideoId;
  @HiveField(1)
  final String songSmallBgVideoUrl;
  @HiveField(2)
  final String songMediumBgVideoUrl;
  @HiveField(3)
  final String songLargeBgVideoUrl;

  const BgVideo({
    required this.songBgVideoId,
    required this.songSmallBgVideoUrl,
    required this.songMediumBgVideoUrl,
    required this.songLargeBgVideoUrl,
  });

  @override
  List<Object?> get props => [
        songBgVideoId,
        songSmallBgVideoUrl,
        songMediumBgVideoUrl,
        songLargeBgVideoUrl,
      ];

  factory BgVideo.fromMap(Map<String, dynamic> map) {
    return new BgVideo(
      songBgVideoId: map['song_bg_video_id'] as int,
      songSmallBgVideoUrl: map['song_small_bg_video_url'] as String,
      songMediumBgVideoUrl: map['song_medium_bg_video_url'] as String,
      songLargeBgVideoUrl: map['song_large_bg_video_url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'song_bg_video_id': this.songBgVideoId,
      'song_small_bg_video_url': this.songSmallBgVideoUrl,
      'song_medium_bg_video_url': this.songMediumBgVideoUrl,
      'song_large_bg_video_url': this.songLargeBgVideoUrl,
    } as Map<String, dynamic>;
  }
}
