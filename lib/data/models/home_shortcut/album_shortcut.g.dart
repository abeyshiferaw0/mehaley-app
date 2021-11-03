// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_shortcut.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumShortcutAdapter extends TypeAdapter<AlbumShortcut> {
  @override
  final int typeId = 20;

  @override
  AlbumShortcut read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumShortcut(
      albumId: fields[0] as int,
      albumTitle: fields[1] as TextLan,
      albumImages: (fields[3] as List).cast<RemoteImage>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlbumShortcut obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.albumId)
      ..writeByte(1)
      ..write(obj.albumTitle)
      ..writeByte(3)
      ..write(obj.albumImages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumShortcutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
