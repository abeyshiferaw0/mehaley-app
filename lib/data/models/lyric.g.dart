// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricAdapter extends TypeAdapter<Lyric> {
  @override
  final int typeId = 4;

  @override
  Lyric read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lyric(
      lyricId: fields[0] as int,
      lyric: fields[1] as TextLan,
    );
  }

  @override
  void write(BinaryWriter writer, Lyric obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lyricId)
      ..writeByte(1)
      ..write(obj.lyric);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LyricAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
