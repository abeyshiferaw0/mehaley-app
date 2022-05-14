import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/payment_error_result.dart';

class CreditCardCheckOutApiResult extends Equatable {
  final String? paymentUrl;
  final CreditCardResult? creditCardResult;
  final PaymentErrorResult? paymentErrorResult;

  const CreditCardCheckOutApiResult({
    required this.creditCardResult,
    required this.paymentErrorResult,
    required this.paymentUrl,
  });

  @override
  List<Object?> get props => [
        creditCardResult,
        paymentErrorResult,
        paymentUrl,
      ];
}

class CreditCardResult extends Equatable {
  final String accessKey;
  final String profileId;
  final String transactionUuid;
  final String signedFieldNames;
  final String unsignedFieldNames;
  final String signedDateTime;
  final String locale;
  final String transactionType;
  final String referenceNumber;
  final String amount;
  final String currency;
  final String signature;

  const CreditCardResult({
    required this.accessKey,
    required this.profileId,
    required this.transactionUuid,
    required this.signedFieldNames,
    required this.unsignedFieldNames,
    required this.signedDateTime,
    required this.locale,
    required this.transactionType,
    required this.referenceNumber,
    required this.amount,
    required this.currency,
    required this.signature,
  });

  @override
  List<Object?> get props => [
        accessKey,
        profileId,
        transactionUuid,
        signedFieldNames,
        unsignedFieldNames,
        signedDateTime,
        locale,
        transactionType,
        referenceNumber,
        amount,
        currency,
        signature,
      ];

  factory CreditCardResult.fromJson(Map<String, dynamic> json) {
    return CreditCardResult(
      accessKey: json["access_key"],
      profileId: json["profile_id"],
      transactionUuid: json["transaction_uuid"],
      signedFieldNames: json["signed_field_names"],
      unsignedFieldNames: json["unsigned_field_names"],
      signedDateTime: json["signed_date_time"],
      locale: json["locale"],
      transactionType: json["transaction_type"],
      referenceNumber: json["reference_number"],
      amount: json["amount"],
      currency: json["currency"],
      signature: json["signature"],
    );
  }

//

}
