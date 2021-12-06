import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/webirr_payment.dart';

class WebirrBill extends Equatable {
  final int webirrTransactionId;
  final WebirrPayment? webirrPayment;
  final String description;
  final double amount;
  final String wbcCode;
  final String billReference;
  final PaymentStatus paymentStatus;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  WebirrBill({
    required this.webirrTransactionId,
    required this.webirrPayment,
    required this.description,
    required this.amount,
    required this.wbcCode,
    required this.billReference,
    required this.paymentStatus,
    required this.dateCreated,
    required this.dateUpdated,
  });

  @override
  List<Object?> get props => [
        webirrTransactionId,
        webirrPayment,
        description,
        amount,
        wbcCode,
        billReference,
        paymentStatus,
        dateCreated,
        dateUpdated,
      ];

  factory WebirrBill.fromMap(Map<String, dynamic> json) {
    return WebirrBill(
      webirrTransactionId: json["webirr_transaction_id"],
      webirrPayment: json["webirr_payment"] != null
          ? WebirrPayment.fromJson(json["webirr_payment"])
          : null,
      description: json["description"],
      amount: json["amount"],
      wbcCode: json["wbc_code"],
      billReference: json["bill_reference"],
      paymentStatus: EnumToString.fromString(
          PaymentStatus.values, json["payment_status"])!,
      dateCreated: DateTime.parse(json["date_created"]),
      dateUpdated: DateTime.parse(json["date_updated"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "webirr_transaction_id": this.webirrTransactionId,
      "webirr_payment": this.webirrPayment,
      "description": this.description,
      "amount": this.amount,
      "wbc_code": this.wbcCode,
      "bill_reference": this.billReference,
      "payment_status": this.paymentStatus,
      "date_created": this.dateCreated.toIso8601String(),
      "date_updated": this.dateUpdated.toIso8601String(),
    };
  }
}
