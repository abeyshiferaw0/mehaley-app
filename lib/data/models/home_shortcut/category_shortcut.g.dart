// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_shortcut.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryShortcutAdapter extends TypeAdapter<CategoryShortcut> {
  @override
  final int typeId = 21;

  @override
  CategoryShortcut read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryShortcut(
      categoryId: fields[0] as int,
      categoryNameText: fields[1] as TextLan,
      categoryImage: fields[2] as RemoteImage,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryShortcut obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.categoryNameText)
      ..writeByte(2)
      ..write(obj.categoryImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryShortcutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
