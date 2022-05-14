import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/credit_card_purchase_provider.dart';
import 'package:mehaley/data/models/api_response/credit_card_check_out_api_result_data.dart';
import 'package:mehaley/data/models/api_response/payment_error_result.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class CreditCardPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final CreditCardPurchaseProvider creditCardPurchaseProvider;

  const CreditCardPurchaseRepository(
      {required this.creditCardPurchaseProvider});

  Future<CreditCardCheckOutApiResult> generateCheckoutUrl(
    int itemId,
    PurchasedItemType purchasedItemType,
  ) async {
    String? paymentUrl;
    CreditCardResult? creditCardResult;
    PaymentErrorResult? paymentErrorResult;

    ///
    paymentUrl = null;
    creditCardResult = null;
    paymentErrorResult = null;

    Response response = await creditCardPurchaseProvider.generateCheckoutUrl(
      itemId,
      purchasedItemType,
    );

    print(
        "CYBER_SOURCE  DATA =>${response.data['cybersource_response']['payment_parameters']}");

    if (response.data['cybersource_response'] != null) {
      ///PARSE PAYMENT URL
      paymentUrl = response.data['cybersource_response']['payment_url'];

      ///PARSE PAYMENT URL
      creditCardResult = CreditCardResult.fromJson(
        response.data['cybersource_response']['payment_parameters'],
      );
    }

    if (response.data['error_response'] != null) {
      ///PARSE PAYMENT URL
      paymentErrorResult =
          PaymentErrorResult.fromJson(response.data['error_response']);
    }

    return CreditCardCheckOutApiResult(
      paymentUrl: paymentUrl,
      creditCardResult: creditCardResult,
      paymentErrorResult: paymentErrorResult,
    );
  }

  cancelDio() {
    creditCardPurchaseProvider.cancel();
  }
}
