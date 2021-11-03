// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_sync.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongSyncAdapter extends TypeAdapter<SongSync> {
  @override
  final int typeId = 17;

  @override
  SongSync read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongSync(
      songId: fields[7] as int,
      uuid: fields[0] as String?,
      playedFrom: fields[1] as SongSyncPlayedFrom,
      playedFromId: fields[2] as int?,
      isPreview: fields[3] as bool,
      isOffline: fields[4] as bool,
      listenDate: fields[5] as String,
      secondsPlayed: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SongSync obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.playedFrom)
      ..writeByte(2)
      ..write(obj.playedFromId)
      ..writeByte(3)
      ..write(obj.isPreview)
      ..writeByte(4)
      ..write(obj.isOffline)
      ..writeByte(5)
      ..write(obj.listenDate)
      ..writeByte(6)
      ..write(obj.secondsPlayed)
      ..writeByte(7)
      ..write(obj.songId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongSyncAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
