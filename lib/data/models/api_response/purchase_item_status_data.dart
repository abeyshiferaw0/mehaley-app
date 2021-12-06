import 'package:equatable/equatable.dart';

class PurchaseItemStatusData extends Equatable {
  final bool isAlreadyPurchased;
  final bool isFree;
  final double balance;
  final double priceEtb;
  final double priceDollar;

  PurchaseItemStatusData({
    required this.isAlreadyPurchased,
    required this.isFree,
    required this.balance,
    required this.priceEtb,
    required this.priceDollar,
  });

  @override
  List<Object?> get props => [
        isAlreadyPurchased,
        isFree,
        balance,
        priceEtb,
        priceDollar,
      ];
}
