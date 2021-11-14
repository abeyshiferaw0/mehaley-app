// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_languages.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final int typeId = 26;

  @override
  AppLanguage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLanguage.ENGLISH;
      case 1:
        return AppLanguage.AMHARIC;
      case 2:
        return AppLanguage.OROMIFA;
      case 3:
        return AppLanguage.TIGRINYA;
      default:
        return AppLanguage.ENGLISH;
    }
  }

  @override
  void write(BinaryWriter writer, AppLanguage obj) {
    switch (obj) {
      case AppLanguage.ENGLISH:
        writer.writeByte(0);
        break;
      case AppLanguage.AMHARIC:
        writer.writeByte(1);
        break;
      case AppLanguage.OROMIFA:
        writer.writeByte(2);
        break;
      case AppLanguage.TIGRINYA:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
