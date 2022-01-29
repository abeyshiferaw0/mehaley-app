import 'package:equatable/equatable.dart';

class TelebirrCheckoutApiResult extends Equatable {
  final String checkOutUrl;
  final String transactionNumber;
  final String resultSuccessRedirectUrl;

  const TelebirrCheckoutApiResult(
      {required this.checkOutUrl,
      required this.transactionNumber,
      required this.resultSuccessRedirectUrl});

  @override
  List<Object?> get props => [
        checkOutUrl,
        transactionNumber,
        resultSuccessRedirectUrl,
      ];
}
