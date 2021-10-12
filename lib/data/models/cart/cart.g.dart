// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  final int typeId = 15;

  @override
  Cart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart(
      playlistCart: fields[0] as PlaylistCart,
      albumCart: fields[1] as AlbumCart,
      songCart: fields[2] as SongCart,
      duplicatedSongs: (fields[3] as List).cast<Song>(),
      deductibleAmountEtb: fields[4] as double,
      deductibleAmountDollar: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.playlistCart)
      ..writeByte(1)
      ..write(obj.albumCart)
      ..writeByte(2)
      ..write(obj.songCart)
      ..writeByte(3)
      ..write(obj.duplicatedSongs)
      ..writeByte(4)
      ..write(obj.deductibleAmountEtb)
      ..writeByte(5)
      ..write(obj.deductibleAmountDollar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
