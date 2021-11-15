import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/text_lan.dart';

part 'lyric.g.dart';

@HiveType(typeId: 4)
class Lyric extends Equatable {
  @HiveField(0)
  final int lyricId;
  @HiveField(1)
  final TextLan lyric;

  const Lyric({
    required this.lyricId,
    required this.lyric,
  });

  @override
  List<Object?> get props => [
        lyricId,
        lyric,
      ];

  factory Lyric.fromMap(Map<String, dynamic> map) {
    return new Lyric(
      lyricId: map['lyric_id'] as int,
      lyric: TextLan.fromMap(map['lyric_text_id']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'lyric_id': this.lyricId,
      'lyric': this.lyric,
    } as Map<String, dynamic>;
  }
}
