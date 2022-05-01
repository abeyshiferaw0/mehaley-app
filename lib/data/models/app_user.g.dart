// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 11;

  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUser(
      userId: fields[0] as int,
      userName: fields[1] as String?,
      userEmail: fields[2] as String?,
      phoneNumberCountryCode: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      isPhoneAuthenticated: fields[5] as bool,
      socialProfileImgUrl: fields[6] as String?,
      authLoginId: fields[7] as String,
      loginType: fields[8] as UserLoginType,
      profileImageId: fields[9] as RemoteImage?,
      dateCreated: fields[10] as DateTime,
      dateModified: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userEmail)
      ..writeByte(3)
      ..write(obj.phoneNumberCountryCode)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.isPhoneAuthenticated)
      ..writeByte(6)
      ..write(obj.socialProfileImgUrl)
      ..writeByte(7)
      ..write(obj.authLoginId)
      ..writeByte(8)
      ..write(obj.loginType)
      ..writeByte(9)
      ..write(obj.profileImageId)
      ..writeByte(10)
      ..write(obj.dateCreated)
      ..writeByte(11)
      ..write(obj.dateModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
