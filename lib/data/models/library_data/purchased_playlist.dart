import 'package:elf_play/data/models/enums/app_payment_methods.dart';
import 'package:elf_play/data/models/enums/setting_enums/app_currency.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:enum_to_string/enum_to_string.dart';

class PurchasedPlaylist {
  final int paymentId;
  final Playlist playlist;
  final DateTime paymentDate;
  final AppPaymentMethods paymentMethod;
  final AppCurrency paymentCurrency;
  final double priceEtb;
  final double priceDollar;

  PurchasedPlaylist({
    required this.paymentId,
    required this.playlist,
    required this.paymentDate,
    required this.paymentMethod,
    required this.paymentCurrency,
    required this.priceEtb,
    required this.priceDollar,
  });

  factory PurchasedPlaylist.fromMap(Map<String, dynamic> map) {
    return PurchasedPlaylist(
      paymentId: map["payment_id"],
      playlist: Playlist.fromMap(map["playlist"]),
      paymentDate: DateTime.parse(map["payment_date"]),
      paymentMethod: EnumToString.fromString(
        AppPaymentMethods.values,
        map["payment_method"],
      ) as AppPaymentMethods,
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
      "playlist": this.playlist,
      "payment_date": this.paymentDate.toIso8601String(),
      "payment_method": this.paymentMethod,
      "payment_currency": this.paymentCurrency,
      "price_etb": this.priceEtb,
      "price_dollar": this.priceDollar,
    };
  }
}
