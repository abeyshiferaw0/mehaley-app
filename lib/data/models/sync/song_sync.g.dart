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
      songId: fields[8] as int,
      uuid: fields[0] as String?,
      playedFrom: fields[1] as SongSyncPlayedFrom,
      playedFromId: fields[2] as int?,
      isPreview: fields[3] as bool,
      isPurchased: fields[4] as bool,
      isOffline: fields[5] as bool,
      listenDate: fields[6] as String,
      secondsPlayed: fields[7] as int?,
      isUserSubscribed: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SongSync obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.playedFrom)
      ..writeByte(2)
      ..write(obj.playedFromId)
      ..writeByte(3)
      ..write(obj.isPreview)
      ..writeByte(4)
      ..write(obj.isPurchased)
      ..writeByte(5)
      ..write(obj.isOffline)
      ..writeByte(6)
      ..write(obj.listenDate)
      ..writeByte(7)
      ..write(obj.secondsPlayed)
      ..writeByte(8)
      ..write(obj.songId)
      ..writeByte(9)
      ..write(obj.isUserSubscribed);
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
