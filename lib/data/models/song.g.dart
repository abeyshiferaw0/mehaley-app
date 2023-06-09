// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 7;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      isBought: fields[9] as bool,
      isDiscountAvailable: fields[10] as bool,
      discountPercentage: fields[12] as double,
      songId: fields[0] as int,
      songName: fields[1] as TextLan,
      albumArt: fields[2] as RemoteImage,
      audioFile: fields[3] as AudioFile,
      artistsName: (fields[4] as List).cast<TextLan>(),
      lyricIncluded: fields[5] as bool,
      priceEtb: fields[6] as double,
      priceDollar: fields[7] as IapProduct,
      isFree: fields[8] as bool,
      isOnlyOnElf: fields[13] as bool,
      performedBy: fields[14] as String,
      writtenByText: fields[15] as String,
      producedBy: fields[16] as String,
      source: fields[17] as String,
      isLiked: fields[19] as bool,
      youtubeUrl: fields[18] as String?,
      releasedDate: fields[20] as DateTime,
      songCreatedDate: fields[21] as DateTime,
      songUpdatedDated: fields[22] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.songName)
      ..writeByte(2)
      ..write(obj.albumArt)
      ..writeByte(3)
      ..write(obj.audioFile)
      ..writeByte(4)
      ..write(obj.artistsName)
      ..writeByte(5)
      ..write(obj.lyricIncluded)
      ..writeByte(6)
      ..write(obj.priceEtb)
      ..writeByte(7)
      ..write(obj.priceDollar)
      ..writeByte(8)
      ..write(obj.isFree)
      ..writeByte(9)
      ..write(obj.isBought)
      ..writeByte(10)
      ..write(obj.isDiscountAvailable)
      ..writeByte(12)
      ..write(obj.discountPercentage)
      ..writeByte(13)
      ..write(obj.isOnlyOnElf)
      ..writeByte(14)
      ..write(obj.performedBy)
      ..writeByte(15)
      ..write(obj.writtenByText)
      ..writeByte(16)
      ..write(obj.producedBy)
      ..writeByte(17)
      ..write(obj.source)
      ..writeByte(18)
      ..write(obj.youtubeUrl)
      ..writeByte(19)
      ..write(obj.isLiked)
      ..writeByte(20)
      ..write(obj.releasedDate)
      ..writeByte(21)
      ..write(obj.songCreatedDate)
      ..writeByte(22)
      ..write(obj.songUpdatedDated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
