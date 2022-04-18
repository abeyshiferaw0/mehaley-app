// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemoteImageAdapter extends TypeAdapter<RemoteImage> {
  @override
  final int typeId = 6;

  @override
  RemoteImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RemoteImage(
      primaryColorHex: fields[10] as String,
      imageId: fields[0] as int,
      imageSmallPath: fields[1] as String,
      imageMediumPath: fields[2] as String,
      imageLargePath: fields[3] as String,
      smallImageWidth: fields[4] as int,
      smallImageHeight: fields[5] as int,
      mediumImageWidth: fields[6] as int,
      mediumImageHeight: fields[7] as int,
      largeImageWidth: fields[8] as int,
      largeImageHeight: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RemoteImage obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.imageId)
      ..writeByte(1)
      ..write(obj.imageMediumPath)
      ..writeByte(2)
      ..write(obj.imageLargePath)
      ..writeByte(3)
      ..write(obj.imageLargePath)
      ..writeByte(4)
      ..write(obj.smallImageWidth)
      ..writeByte(5)
      ..write(obj.smallImageHeight)
      ..writeByte(6)
      ..write(obj.mediumImageWidth)
      ..writeByte(7)
      ..write(obj.mediumImageHeight)
      ..writeByte(8)
      ..write(obj.largeImageWidth)
      ..writeByte(9)
      ..write(obj.largeImageHeight)
      ..writeByte(10)
      ..write(obj.primaryColorHex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemoteImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
