// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_song_quality.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadSongQualityAdapter extends TypeAdapter<DownloadSongQuality> {
  @override
  final int typeId = 12;

  @override
  DownloadSongQuality read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadSongQuality.LOW_QUALITY;
      case 1:
        return DownloadSongQuality.MEDIUM_QUALITY;
      case 2:
        return DownloadSongQuality.HIGH_QUALITY;
      default:
        return DownloadSongQuality.LOW_QUALITY;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadSongQuality obj) {
    switch (obj) {
      case DownloadSongQuality.LOW_QUALITY:
        writer.writeByte(0);
        break;
      case DownloadSongQuality.MEDIUM_QUALITY:
        writer.writeByte(1);
        break;
      case DownloadSongQuality.HIGH_QUALITY:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadSongQualityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
