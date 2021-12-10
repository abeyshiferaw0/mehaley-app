import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';

class PurchaseItemStatusData extends Equatable {
  final bool isAlreadyPurchased;
  final bool isFree;
  final double balance;
  final WebirrBill? freshBill;
  final List<WalletGift> freshWalletGifts;
  final double priceEtb;
  final double priceDollar;

  PurchaseItemStatusData({
    required this.isAlreadyPurchased,
    required this.isFree,
    required this.balance,
    required this.freshBill,
    required this.freshWalletGifts,
    required this.priceEtb,
    required this.priceDollar,
  });

  @override
  List<Object?> get props => [
        isAlreadyPurchased,
        isFree,
        balance,
        freshBill,
        freshWalletGifts,
        priceEtb,
        priceDollar,
      ];
}
