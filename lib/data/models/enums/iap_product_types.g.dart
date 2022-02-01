// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_product_types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IapProductTypesAdapter extends TypeAdapter<IapProductTypes> {
  @override
  final int typeId = 15;

  @override
  IapProductTypes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IapProductTypes.SONG;
      case 1:
        return IapProductTypes.ALBUM;
      case 2:
        return IapProductTypes.PLAYLIST;
      default:
        return IapProductTypes.SONG;
    }
  }

  @override
  void write(BinaryWriter writer, IapProductTypes obj) {
    switch (obj) {
      case IapProductTypes.SONG:
        writer.writeByte(0);
        break;
      case IapProductTypes.ALBUM:
        writer.writeByte(1);
        break;
      case IapProductTypes.PLAYLIST:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IapProductTypesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
