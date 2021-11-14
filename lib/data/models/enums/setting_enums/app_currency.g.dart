// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_currency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppCurrencyAdapter extends TypeAdapter<AppCurrency> {
  @override
  final int typeId = 25;

  @override
  AppCurrency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppCurrency.ETB;
      case 1:
        return AppCurrency.USD;
      default:
        return AppCurrency.ETB;
    }
  }

  @override
  void write(BinaryWriter writer, AppCurrency obj) {
    switch (obj) {
      case AppCurrency.ETB:
        writer.writeByte(0);
        break;
      case AppCurrency.USD:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCurrencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
