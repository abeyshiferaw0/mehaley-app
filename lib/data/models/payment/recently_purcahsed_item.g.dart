// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_purcahsed_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyPurchasedItemAdapter extends TypeAdapter<RecentlyPurchasedItem> {
  @override
  final int typeId = 14;

  @override
  RecentlyPurchasedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPurchasedItem(
      itemId: fields[0] as int,
      purchasedItemType: fields[1] as PurchasedItemType,
      millisecondsSinceEpoch: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPurchasedItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.purchasedItemType)
      ..writeByte(2)
      ..write(obj.millisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyPurchasedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
