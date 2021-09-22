// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_lan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextLanAdapter extends TypeAdapter<TextLan> {
  @override
  final int typeId = 8;

  @override
  TextLan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextLan(
      textLanguageId: fields[0] as int?,
      textEn: fields[1] as String,
      textAm: fields[2] as String,
      textOro: fields[3] as String,
      textTig: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TextLan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.textLanguageId)
      ..writeByte(1)
      ..write(obj.textEn)
      ..writeByte(2)
      ..write(obj.textAm)
      ..writeByte(3)
      ..write(obj.textOro)
      ..writeByte(4)
      ..write(obj.textTig);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextLanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
