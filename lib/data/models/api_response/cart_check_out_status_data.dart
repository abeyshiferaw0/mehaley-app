import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';

class CartCheckOutStatusData extends Equatable {
  final double balance;
  final double cartTotalEtb;
  final WebirrBill? freshBill;
  final List<WalletGift> freshWalletGifts;

  CartCheckOutStatusData({
    required this.freshWalletGifts,
    required this.balance,
    required this.freshBill,
    required this.cartTotalEtb,
  });

  @override
  List<Object?> get props => [
        balance,
        freshBill,
        freshWalletGifts,
        cartTotalEtb,
      ];
}
