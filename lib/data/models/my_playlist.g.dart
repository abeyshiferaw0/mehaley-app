// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyPlaylistAdapter extends TypeAdapter<MyPlaylist> {
  @override
  final int typeId = 13;

  @override
  MyPlaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPlaylist(
      numberOfSongs: fields[16] as int,
      gridSongImages: (fields[4] as List).cast<RemoteImage>(),
      songs: (fields[15] as List?)?.cast<Song>(),
      playlistId: fields[0] as int,
      playlistNameText: fields[1] as TextLan,
      playlistDescriptionText: fields[2] as TextLan,
      playlistImage: fields[3] as RemoteImage?,
      isVerified: fields[5] as bool,
      isFeatured: fields[6] as bool,
      priceEtb: fields[7] as double,
      priceDollar: fields[8] as double,
      isFree: fields[9] as bool,
      isDiscountAvailable: fields[10] as bool,
      discountPercentage: fields[11] as double,
      isFollowed: fields[12] as bool?,
      playlistDateCreated: fields[13] as DateTime,
      playlistDateUpdated: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MyPlaylist obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.playlistId)
      ..writeByte(1)
      ..write(obj.playlistNameText)
      ..writeByte(2)
      ..write(obj.playlistDescriptionText)
      ..writeByte(3)
      ..write(obj.playlistImage)
      ..writeByte(4)
      ..write(obj.gridSongImages)
      ..writeByte(5)
      ..write(obj.isVerified)
      ..writeByte(6)
      ..write(obj.isFeatured)
      ..writeByte(7)
      ..write(obj.priceEtb)
      ..writeByte(8)
      ..write(obj.priceDollar)
      ..writeByte(9)
      ..write(obj.isFree)
      ..writeByte(10)
      ..write(obj.isDiscountAvailable)
      ..writeByte(11)
      ..write(obj.discountPercentage)
      ..writeByte(12)
      ..write(obj.isFollowed)
      ..writeByte(13)
      ..write(obj.playlistDateCreated)
      ..writeByte(14)
      ..write(obj.playlistDateUpdated)
      ..writeByte(15)
      ..write(obj.songs)
      ..writeByte(16)
      ..write(obj.numberOfSongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
