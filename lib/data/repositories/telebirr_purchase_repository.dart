import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/telebirr_purchase_provider.dart';
import 'package:mehaley/data/models/api_response/telebirr_checkout_api_result.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class TelebirrPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final TelebirrPurchaseProvider telebirrPurchaseProvider;

  const TelebirrPurchaseRepository({required this.telebirrPurchaseProvider});

  Future<TelebirrCheckoutApiResult> generateCheckoutUrl(
    int itemId,
    AppPurchasedItemType appPurchasedItemType,
  ) async {
    Response response = await telebirrPurchaseProvider.generateCheckoutUrl(
      itemId,
      appPurchasedItemType,
    );

    print("TELEBIRR  DATA => ${response.data}");
    if (response.statusCode == 200) {
      ///
      String checkOutUrl = response.data['payment_url'];
      String transactionNumber =
          generateTransactionNumber(response.data['payment_url']);
      String resultSuccessRedirectUrl = response.data['redirect_url'];

      ///
      TelebirrCheckoutApiResult telebirrCheckoutApiResult =
          TelebirrCheckoutApiResult(
        checkOutUrl: checkOutUrl,
        transactionNumber: transactionNumber,
        resultSuccessRedirectUrl: resultSuccessRedirectUrl,
      );
      return telebirrCheckoutApiResult;
    }

    throw "UNABLE TO GENERATE TELEBIRR PURCHASE URL";
  }

  String generateTransactionNumber(
    String chUrl,
  ) {
    String checkoutUrl = chUrl;
    if (checkoutUrl.contains('#')) {
      checkoutUrl = checkoutUrl.replaceAll('/#/', '/');
    }
    Uri url = Uri.parse(checkoutUrl);

    if (url.queryParameters['transactionNo'] != null) {
      return url.queryParameters['transactionNo']!;
    }

    throw "transactionNo NOT FOUND FROM checkoutUrl";
  }

  cancelDio() {
    telebirrPurchaseProvider.cancel();
  }
}
