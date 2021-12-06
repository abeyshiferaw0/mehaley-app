import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class WalletHistory extends Equatable {
  final int paymentHistoryId;
  final double amount;
  final PurchasedItemType walletHistoryItemType;
  final PaymentType paymentType;
  final DateTime dateCreated;

  WalletHistory({
    required this.paymentHistoryId,
    required this.amount,
    required this.walletHistoryItemType,
    required this.paymentType,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [
        paymentHistoryId,
        amount,
        walletHistoryItemType,
        paymentType,
        dateCreated,
      ];

  factory WalletHistory.fromMap(Map<String, dynamic> json) {
    return WalletHistory(
      paymentHistoryId: json["payment_history_id"],
      amount: json["amount"],
      walletHistoryItemType: EnumToString.fromString(
          PurchasedItemType.values, json["item_type"])!,
      paymentType:
          EnumToString.fromString(PaymentType.values, json["payment_type"])!,
      dateCreated: DateTime.parse(json["date_created"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "payment_history_id": this.paymentHistoryId,
      "amount": this.amount,
      "item_type": this.walletHistoryItemType,
      "payment_type": this.paymentType,
      "date_created": this.dateCreated.toIso8601String(),
    };
  }
}
