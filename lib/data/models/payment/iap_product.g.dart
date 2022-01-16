// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IapProductAdapter extends TypeAdapter<IapProduct> {
  @override
  final int typeId = 20;

  @override
  IapProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IapProduct(
      productId: fields[0] as String,
      productPrice: fields[1] as double,
      iapProductType: fields[2] as IapProductTypes,
    );
  }

  @override
  void write(BinaryWriter writer, IapProduct obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productPrice)
      ..writeByte(2)
      ..write(obj.iapProductType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IapProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
