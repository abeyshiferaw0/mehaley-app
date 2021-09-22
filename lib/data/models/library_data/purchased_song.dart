import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:enum_to_string/enum_to_string.dart';

class PurchasedSong {
  final int paymentId;
  final Song song;
  final DateTime paymentDate;
  final AppPaymentMethod paymentMethod;
  final AppCurrency paymentCurrency;
  final double priceEtb;
  final double priceDollar;

  PurchasedSong({
    required this.paymentId,
    required this.song,
    required this.paymentDate,
    required this.paymentMethod,
    required this.paymentCurrency,
    required this.priceEtb,
    required this.priceDollar,
  });

  factory PurchasedSong.fromMap(Map<String, dynamic> map) {
    return PurchasedSong(
      paymentId: map["payment_id"],
      song: Song.fromMap(map["song"]),
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
      "song": this.song,
      "payment_date": this.paymentDate.toIso8601String(),
      "payment_method": this.paymentMethod,
      "payment_currency": this.paymentCurrency,
      "price_etb": this.priceEtb,
      "price_dollar": this.priceDollar,
    };
  }
}
