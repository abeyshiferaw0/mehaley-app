import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/wallet_history.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/text_lan.dart';

class WalletGift extends Equatable {
  final int giftId;
  final TextLan title;
  final TextLan subTitle;
  final TextLan source;
  final RemoteImage image;
  final WalletHistory walletHistory;
  final DateTime dateCreated;

  WalletGift({
    required this.walletHistory,
    required this.giftId,
    required this.title,
    required this.source,
    required this.subTitle,
    required this.image,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [
        giftId,
        title,
        subTitle,
        source,
        image,
        dateCreated,
      ];

  factory WalletGift.fromMap(Map<String, dynamic> json) {
    return WalletGift(
      giftId: json["gift"]["gift_id"],
      title: TextLan.fromMap(json["gift"]["title"]),
      subTitle: TextLan.fromMap(json["gift"]["sub_title"]),
      source: TextLan.fromMap(json["gift"]["source"]),
      image: RemoteImage.fromMap(json["gift"]["image"]),
      walletHistory: WalletHistory.fromMap(json["payment_history"]),
      dateCreated: DateTime.parse(json["gift"]["date_created"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gift_id": this.giftId,
      "title": this.title,
      "sub_title": this.subTitle,
      "image": this.image,
      "date_created": this.dateCreated.toIso8601String(),
    };
  }
}
