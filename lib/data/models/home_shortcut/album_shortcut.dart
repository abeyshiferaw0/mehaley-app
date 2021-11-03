import 'package:elf_play/data/models/remote_image.dart';
import 'package:elf_play/data/models/text_lan.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'album_shortcut.g.dart';

@HiveType(typeId: 20)
class AlbumShortcut extends Equatable {
  @HiveField(0)
  final int albumId;
  @HiveField(1)
  final TextLan albumTitle;
  @HiveField(3)
  final List<RemoteImage> albumImages;

  const AlbumShortcut({
    required this.albumId,
    required this.albumTitle,
    required this.albumImages,
  });

  @override
  List<Object?> get props => [
        albumId,
        albumTitle,
        albumImages,
      ];

  factory AlbumShortcut.fromMap(Map<String, dynamic> map) {
    return new AlbumShortcut(
      albumId: map['album_id'] as int,
      albumTitle: TextLan.fromMap(map['album_title_text_id']),
      albumImages: (map['album_images'] as List).length > 0
          ? (map['album_images'] as List)
              .map((remoteImage) => RemoteImage.fromMap(remoteImage))
              .toList()
          : [RemoteImage.emptyRemoteImage()],
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'album_id': this.albumId,
      'album_title_text': this.albumTitle,
      'album_images': this.albumImages,
    } as Map<String, dynamic>;
  }
}
