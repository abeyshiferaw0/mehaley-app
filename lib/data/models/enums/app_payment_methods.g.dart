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
        return AppPaymentMethods.METHOD_AMOLE;
      case 1:
        return AppPaymentMethods.METHOD_CBE_BIRR;
      case 2:
        return AppPaymentMethods.METHOD_HELLO_CASH;
      case 3:
        return AppPaymentMethods.METHOD_MBIRR;
      case 4:
        return AppPaymentMethods.METHOD_VISA;
      case 5:
        return AppPaymentMethods.METHOD_MASTERCARD;
      case 6:
        return AppPaymentMethods.METHOD_UNK;
      default:
        return AppPaymentMethods.METHOD_AMOLE;
    }
  }

  @override
  void write(BinaryWriter writer, AppPaymentMethods obj) {
    switch (obj) {
      case AppPaymentMethods.METHOD_AMOLE:
        writer.writeByte(0);
        break;
      case AppPaymentMethods.METHOD_CBE_BIRR:
        writer.writeByte(1);
        break;
      case AppPaymentMethods.METHOD_HELLO_CASH:
        writer.writeByte(2);
        break;
      case AppPaymentMethods.METHOD_MBIRR:
        writer.writeByte(3);
        break;
      case AppPaymentMethods.METHOD_VISA:
        writer.writeByte(4);
        break;
      case AppPaymentMethods.METHOD_MASTERCARD:
        writer.writeByte(5);
        break;
      case AppPaymentMethods.METHOD_UNK:
        writer.writeByte(6);
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
