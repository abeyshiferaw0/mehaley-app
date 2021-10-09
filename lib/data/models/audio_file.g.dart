// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioFileAdapter extends TypeAdapter<AudioFile> {
  @override
  final int typeId = 2;

  @override
  AudioFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioFile(
      audioId: fields[0] as int,
      audioDurationSeconds: fields[1] as double,
      audioSmallPath: fields[2] as String,
      audioMediumPath: fields[3] as String,
      audioLargePath: fields[4] as String,
      audioSmallSize: fields[5] as double,
      audioMediumSize: fields[6] as double,
      audioLargeSize: fields[7] as double,
      audio96KpsStreamPath: fields[8] as String,
      audio128KpsStreamPath: fields[9] as String,
      audio160KpsStreamPath: fields[10] as String,
      audioPreviewDurationSeconds: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AudioFile obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.audioId)
      ..writeByte(1)
      ..write(obj.audioDurationSeconds)
      ..writeByte(2)
      ..write(obj.audioSmallPath)
      ..writeByte(3)
      ..write(obj.audioMediumPath)
      ..writeByte(4)
      ..write(obj.audioLargePath)
      ..writeByte(5)
      ..write(obj.audioSmallSize)
      ..writeByte(6)
      ..write(obj.audioMediumSize)
      ..writeByte(7)
      ..write(obj.audioLargeSize)
      ..writeByte(8)
      ..write(obj.audio96KpsStreamPath)
      ..writeByte(9)
      ..write(obj.audio128KpsStreamPath)
      ..writeByte(10)
      ..write(obj.audio160KpsStreamPath)
      ..writeByte(11)
      ..write(obj.audioPreviewDurationSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
