// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_shortcut.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistShortcutAdapter extends TypeAdapter<PlaylistShortcut> {
  @override
  final int typeId = 22;

  @override
  PlaylistShortcut read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistShortcut(
      playlistId: fields[0] as int,
      playlistNameText: fields[1] as TextLan,
      playlistImage: fields[3] as RemoteImage,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistShortcut obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.playlistNameText)
      ..writeByte(3)
      ..write(obj.playlistImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistShortcutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
