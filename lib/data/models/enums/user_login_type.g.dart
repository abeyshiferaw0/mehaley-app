// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLoginTypeAdapter extends TypeAdapter<UserLoginType> {
  @override
  final int typeId = 10;

  @override
  UserLoginType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserLoginType.PHONE_NUMBER;
      case 1:
        return UserLoginType.GOOGLE;
      case 2:
        return UserLoginType.FACEBOOK;
      case 3:
        return UserLoginType.APPLE;
      case 4:
        return UserLoginType.NONE;
      default:
        return UserLoginType.PHONE_NUMBER;
    }
  }

  @override
  void write(BinaryWriter writer, UserLoginType obj) {
    switch (obj) {
      case UserLoginType.PHONE_NUMBER:
        writer.writeByte(0);
        break;
      case UserLoginType.GOOGLE:
        writer.writeByte(1);
        break;
      case UserLoginType.FACEBOOK:
        writer.writeByte(2);
        break;
      case UserLoginType.APPLE:
        writer.writeByte(3);
        break;
      case UserLoginType.NONE:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLoginTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
