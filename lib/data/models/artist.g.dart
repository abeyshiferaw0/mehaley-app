// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final int typeId = 1;

  @override
  Artist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artist(
      artistId: fields[0] as int,
      artistName: fields[1] as TextLan,
      artistAboutBiography: fields[2] as TextLan,
      artistImages: (fields[3] as List).cast<RemoteImage>(),
      isVerified: fields[4] as bool,
      isSuggested: fields[5] as bool,
      artistAboutSocialLinks: fields[6] as String,
      isFollowed: fields[7] as bool?,
      artistDateCreated: fields[8] as DateTime,
      artistDateUpdated: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.artistId)
      ..writeByte(1)
      ..write(obj.artistName)
      ..writeByte(2)
      ..write(obj.artistAboutBiography)
      ..writeByte(3)
      ..write(obj.artistImages)
      ..writeByte(4)
      ..write(obj.isVerified)
      ..writeByte(5)
      ..write(obj.isSuggested)
      ..writeByte(6)
      ..write(obj.artistAboutSocialLinks)
      ..writeByte(7)
      ..write(obj.isFollowed)
      ..writeByte(8)
      ..write(obj.artistDateCreated)
      ..writeByte(9)
      ..write(obj.artistDateUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
