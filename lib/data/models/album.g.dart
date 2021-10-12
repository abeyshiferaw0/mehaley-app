// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumAdapter extends TypeAdapter<Album> {
  @override
  final int typeId = 0;

  @override
  Album read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Album(
      isBought: fields[10] as bool,
      albumId: fields[0] as int,
      albumTitle: fields[1] as TextLan,
      albumDescription: fields[2] as TextLan,
      albumImages: (fields[3] as List).cast<RemoteImage>(),
      songs: (fields[4] as List?)?.cast<Song>(),
      artist: fields[5] as Artist,
      priceEtb: fields[6] as double,
      priceDollar: fields[7] as double,
      isFree: fields[8] as bool,
      isDiscountAvailable: fields[9] as bool,
      discountPercentage: fields[11] as double,
      isOnlyOnElf: fields[12] as bool,
      isFeatured: fields[13] as bool,
      isLiked: fields[14] as bool,
      isInCart: fields[15] as bool,
      albumReleaseDate: fields[16] as DateTime,
      albumDateCreated: fields[17] as DateTime,
      albumDateUpdated: fields[18] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Album obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.albumId)
      ..writeByte(1)
      ..write(obj.albumTitle)
      ..writeByte(2)
      ..write(obj.albumDescription)
      ..writeByte(3)
      ..write(obj.albumImages)
      ..writeByte(4)
      ..write(obj.songs)
      ..writeByte(5)
      ..write(obj.artist)
      ..writeByte(6)
      ..write(obj.priceEtb)
      ..writeByte(7)
      ..write(obj.priceDollar)
      ..writeByte(8)
      ..write(obj.isFree)
      ..writeByte(9)
      ..write(obj.isDiscountAvailable)
      ..writeByte(10)
      ..write(obj.isBought)
      ..writeByte(11)
      ..write(obj.discountPercentage)
      ..writeByte(12)
      ..write(obj.isOnlyOnElf)
      ..writeByte(13)
      ..write(obj.isFeatured)
      ..writeByte(14)
      ..write(obj.isLiked)
      ..writeByte(15)
      ..write(obj.isInCart)
      ..writeByte(16)
      ..write(obj.albumReleaseDate)
      ..writeByte(17)
      ..write(obj.albumDateCreated)
      ..writeByte(18)
      ..write(obj.albumDateUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
