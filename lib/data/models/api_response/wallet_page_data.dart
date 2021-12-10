import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';

class WalletPageData extends Equatable {
  final WebirrBill? freshBill;
  final WebirrBill? activeBill;
  final double walletBalance;
  final List<WalletGift> freshWalletGifts;
  final List<PaymentMethod> paymentMethods;
  final DateTime today;
  final Response response;

  const WalletPageData({
    required this.paymentMethods,
    required this.freshBill,
    required this.activeBill,
    required this.freshWalletGifts,
    required this.walletBalance,
    required this.today,
    required this.response,
  });

  @override
  List<Object?> get props => [
        paymentMethods,
        freshBill,
        activeBill,
        walletBalance,
        today,
        freshWalletGifts,
        response,
      ];
}
