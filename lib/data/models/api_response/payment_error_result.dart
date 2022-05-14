import 'package:equatable/equatable.dart';

class PaymentErrorResult extends Equatable {
  final bool isFree;
  final bool isAlreadyBought;

  const PaymentErrorResult({
    required this.isFree,
    required this.isAlreadyBought,
  });

  @override
  List<Object?> get props => [
        isFree,
        isAlreadyBought,
      ];

  factory PaymentErrorResult.fromJson(Map<String, dynamic> json) {
    return PaymentErrorResult(
      isFree: json["free"] == 1 ? true : false,
      isAlreadyBought: json["exists"] == 1 ? true : false,
    );
  }
//

}
