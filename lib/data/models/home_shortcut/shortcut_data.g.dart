// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShortcutDataAdapter extends TypeAdapter<ShortcutData> {
  @override
  final int typeId = 23;

  @override
  ShortcutData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShortcutData(
      purchasedCount: fields[0] as int,
      downloadCount: fields[1] as int,
      shortcuts: (fields[3] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShortcutData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.purchasedCount)
      ..writeByte(1)
      ..write(obj.downloadCount)
      ..writeByte(3)
      ..write(obj.shortcuts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortcutDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
