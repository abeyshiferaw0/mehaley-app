import 'package:elf_play/config/enums.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../album.dart';

class PurchasedAlbum {
  final int paymentId;
  final Album album;
  final DateTime paymentDate;
  final AppPaymentMethod paymentMethod;
  final AppCurrency paymentCurrency;
  final double priceEtb;
  final double priceDollar;

  PurchasedAlbum({
    required this.paymentId,
    required this.album,
    required this.paymentDate,
    required this.paymentMethod,
    required this.paymentCurrency,
    required this.priceEtb,
    required this.priceDollar,
  });

  factory PurchasedAlbum.fromMap(Map<String, dynamic> map) {
    return PurchasedAlbum(
      paymentId: map["payment_id"],
      album: Album.fromMap(map["album"]),
      paymentDate: DateTime.parse(map["payment_date"]),
      paymentMethod: EnumToString.fromString(
        AppPaymentMethod.values,
        map["payment_method"],
      ) as AppPaymentMethod,
      paymentCurrency: EnumToString.fromString(
        AppCurrency.values,
        map["payment_currency"],
      ) as AppCurrency,
      priceEtb: map["price_etb"],
      priceDollar: map["price_dollar"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "payment_id": this.paymentId,
      "album": this.album,
      "payment_date": this.paymentDate.toIso8601String(),
      "payment_method": this.paymentMethod,
      "payment_currency": this.paymentCurrency,
      "price_etb": this.priceEtb,
      "price_dollar": this.priceDollar,
    };
  }
}
