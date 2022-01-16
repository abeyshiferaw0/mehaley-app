// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_payment_methods.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppPaymentMethodsAdapter extends TypeAdapter<AppPaymentMethods> {
  @override
  final int typeId = 24;

  @override
  AppPaymentMethods read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppPaymentMethods.METHOD_YENEPAY;
      case 1:
        return AppPaymentMethods.METHOD_TELEBIRR;
      case 2:
        return AppPaymentMethods.METHOD_INAPP;
      case 3:
        return AppPaymentMethods.METHOD_UNK;
      default:
        return AppPaymentMethods.METHOD_YENEPAY;
    }
  }

  @override
  void write(BinaryWriter writer, AppPaymentMethods obj) {
    switch (obj) {
      case AppPaymentMethods.METHOD_YENEPAY:
        writer.writeByte(0);
        break;
      case AppPaymentMethods.METHOD_TELEBIRR:
        writer.writeByte(1);
        break;
      case AppPaymentMethods.METHOD_INAPP:
        writer.writeByte(2);
        break;
      case AppPaymentMethods.METHOD_UNK:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPaymentMethodsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
