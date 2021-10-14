// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 5;

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlist(
      isBought: fields[10] as bool,
      numberOfFollowers: fields[16] as int?,
      songs: (fields[19] as List?)?.cast<Song>(),
      playlistId: fields[0] as int,
      playlistNameText: fields[1] as TextLan,
      playlistDescriptionText: fields[2] as TextLan,
      playlistImage: fields[3] as RemoteImage,
      isVerified: fields[4] as bool,
      isFeatured: fields[5] as bool,
      priceEtb: fields[6] as double,
      priceDollar: fields[7] as double,
      isFree: fields[8] as bool,
      isDiscountAvailable: fields[9] as bool,
      discountPercentage: fields[11] as double,
      createdBy: fields[12] as PlaylistCreatedBy,
      createdById: fields[13] as String,
      isFollowed: fields[14] as bool?,
      isInCart: fields[15] as bool,
      playlistDateCreated: fields[17] as DateTime,
      playlistDateUpdated: fields[18] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.playlistNameText)
      ..writeByte(2)
      ..write(obj.playlistDescriptionText)
      ..writeByte(3)
      ..write(obj.playlistImage)
      ..writeByte(4)
      ..write(obj.isVerified)
      ..writeByte(5)
      ..write(obj.isFeatured)
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
      ..write(obj.createdBy)
      ..writeByte(13)
      ..write(obj.createdById)
      ..writeByte(14)
      ..write(obj.isFollowed)
      ..writeByte(15)
      ..write(obj.isInCart)
      ..writeByte(16)
      ..write(obj.numberOfFollowers)
      ..writeByte(17)
      ..write(obj.playlistDateCreated)
      ..writeByte(18)
      ..write(obj.playlistDateUpdated)
      ..writeByte(19)
      ..write(obj.songs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PlaylistAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
