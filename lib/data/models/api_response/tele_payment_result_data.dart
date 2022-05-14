import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/payment_error_result.dart';

class TelePaymentResultData extends Equatable {
  final TeleResult? teleResult;
  final PaymentErrorResult? paymentErrorResult;

  const TelePaymentResultData({
    required this.teleResult,
    required this.paymentErrorResult,
  });

  @override
  List<Object?> get props => [
        teleResult,
        paymentErrorResult,
      ];
}

class TeleResult extends Equatable {
  final bool status;
  final String? transId;
  final bool isBalanceNotEnough;

  const TeleResult({
    required this.status,
    required this.isBalanceNotEnough,
    required this.transId,
  });

  @override
  List<Object?> get props => [
        status,
        isBalanceNotEnough,
        transId,
      ];

  factory TeleResult.fromJson(Map<String, dynamic> json) {
    return TeleResult(
      status: json['status'] == 1 ? true : false,
      transId: json['transactionId'],
      isBalanceNotEnough: json['balanceNotEnough'] == 1 ? true : false,
    );
  }
//

}
