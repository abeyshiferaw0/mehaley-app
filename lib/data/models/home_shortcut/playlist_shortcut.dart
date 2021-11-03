import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'playlist_shortcut.g.dart';

@HiveType(typeId: 22)
class PlaylistShortcut extends Equatable {
  @HiveField(0)
  final int playlistId;
  @HiveField(1)
  final TextLan playlistNameText;
  @HiveField(3)
  final RemoteImage playlistImage;

  const PlaylistShortcut({
    required this.playlistId,
    required this.playlistNameText,
    required this.playlistImage,
  });

  @override
  List<Object?> get props => [
        playlistId,
        playlistNameText,
        playlistImage,
      ];

  factory PlaylistShortcut.fromMap(Map<String, dynamic> map) {
    return new PlaylistShortcut(
      playlistId: map['playlist_id'] as int,
      playlistNameText: TextLan.fromMap(
        map['playlist_name_text_id'],
      ),
      playlistImage: RemoteImage.fromMap(
        map['playlist_image_id'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'playlist_id': this.playlistId,
      'playlist_name_text': this.playlistNameText,
      'playlist_image': this.playlistImage,
    } as Map<String, dynamic>;
  }
}
