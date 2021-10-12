// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumCartAdapter extends TypeAdapter<AlbumCart> {
  @override
  final int typeId = 14;

  @override
  AlbumCart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumCart(
      cartId: fields[0] as int,
      items: (fields[1] as List).cast<Album>(),
      totalPriceEtb: fields[2] as double,
      totalPriceDollar: fields[3] as double,
      dateCreated: fields[4] as DateTime,
      dateUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumCart obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.cartId)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.totalPriceEtb)
      ..writeByte(3)
      ..write(obj.totalPriceDollar)
      ..writeByte(4)
      ..write(obj.dateCreated)
      ..writeByte(5)
      ..write(obj.dateUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumCartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
