// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bg_video.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BgVideoAdapter extends TypeAdapter<BgVideo> {
  @override
  final int typeId = 3;

  @override
  BgVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BgVideo(
      songBgVideoId: fields[0] as int,
      songSmallBgVideoUrl: fields[1] as String,
      songMediumBgVideoUrl: fields[2] as String,
      songLargeBgVideoUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BgVideo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.songBgVideoId)
      ..writeByte(1)
      ..write(obj.songSmallBgVideoUrl)
      ..writeByte(2)
      ..write(obj.songMediumBgVideoUrl)
      ..writeByte(3)
      ..write(obj.songLargeBgVideoUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BgVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
