// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_created_by.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistCreatedByAdapter extends TypeAdapter<PlaylistCreatedBy> {
  @override
  final int typeId = 9;

  @override
  PlaylistCreatedBy read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlaylistCreatedBy.ADMIN;
      case 1:
        return PlaylistCreatedBy.USER;
      case 2:
        return PlaylistCreatedBy.AUTO_GENERATED;
      default:
        return PlaylistCreatedBy.ADMIN;
    }
  }

  @override
  void write(BinaryWriter writer, PlaylistCreatedBy obj) {
    switch (obj) {
      case PlaylistCreatedBy.ADMIN:
        writer.writeByte(0);
        break;
      case PlaylistCreatedBy.USER:
        writer.writeByte(1);
        break;
      case PlaylistCreatedBy.AUTO_GENERATED:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistCreatedByAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
