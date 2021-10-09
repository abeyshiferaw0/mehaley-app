import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'audio_file.g.dart';

@HiveType(typeId: 2)
class AudioFile extends Equatable {
  @HiveField(0)
  final int audioId;
  @HiveField(1)
  final double audioDurationSeconds;
  @HiveField(2)
  final String audioSmallPath;
  @HiveField(3)
  final String audioMediumPath;
  @HiveField(4)
  final String audioLargePath;
  @HiveField(5)
  final double audioSmallSize;
  @HiveField(6)
  final double audioMediumSize;
  @HiveField(7)
  final double audioLargeSize;
  @HiveField(8)
  final String audio96KpsStreamPath;
  @HiveField(9)
  final String audio128KpsStreamPath;
  @HiveField(10)
  final String audio160KpsStreamPath;
  @HiveField(11)
  final double audioPreviewDurationSeconds;

  AudioFile({
    required this.audioId,
    required this.audioDurationSeconds,
    required this.audioSmallPath,
    required this.audioMediumPath,
    required this.audioLargePath,
    required this.audioSmallSize,
    required this.audioMediumSize,
    required this.audioLargeSize,
    required this.audio96KpsStreamPath,
    required this.audio128KpsStreamPath,
    required this.audio160KpsStreamPath,
    required this.audioPreviewDurationSeconds,
  });

  @override
  List<Object> get props => [
        audioId,
        audioDurationSeconds,
        audioSmallPath,
        audioMediumPath,
        audioLargePath,
        audioSmallSize,
        audioMediumSize,
        audioLargeSize,
        audio96KpsStreamPath,
        audio128KpsStreamPath,
        audio160KpsStreamPath,
        audioPreviewDurationSeconds,
      ];

  factory AudioFile.fromMap(Map<String, dynamic> map) {
    return new AudioFile(
      audioId: map['audio_id'] as int,
      audioDurationSeconds: map['audio_duration_seconds'] as double,
      audioSmallPath: map['audio_small_path'],
      audioMediumPath: map['audio_medium_path'],
      audioLargePath: map['audio_large_path'],
      audioSmallSize: map['audio_small_size'],
      audioMediumSize: map['audio_medium_size'],
      audioLargeSize: map['audio_large_size'],
      audio96KpsStreamPath: map['audio_96kps_stream_path'],
      audio128KpsStreamPath: map['audio_128kps_stream_path'],
      audio160KpsStreamPath: map['audio_160kps_stream_path'] as String,
      audioPreviewDurationSeconds:
          map['audio_preview_duration_seconds'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'audio_id': this.audioId,
      'audio_duration_seconds': this.audioDurationSeconds,
      'audio_small_path': this.audioSmallPath,
      'audio_medium_path': this.audioMediumPath,
      'audio_large_path': this.audioLargePath,
      'audio_small_size': this.audioSmallSize,
      'audio_medium_size': this.audioMediumSize,
      'audio_large_size': this.audioLargeSize,
      'audio_96kps_stream_path': this.audio96KpsStreamPath,
      'audio_128kps_stream_path': this.audio128KpsStreamPath,
      'audio_160kps_stream_path': this.audio160KpsStreamPath,
      'audio_preview_duration_seconds': this.audioPreviewDurationSeconds,
    } as Map<String, dynamic>;
  }
}
