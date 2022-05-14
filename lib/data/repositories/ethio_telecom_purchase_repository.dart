import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/ethio_telecom_purchase_provider.dart';
import 'package:mehaley/data/models/api_response/payment_error_result.dart';
import 'package:mehaley/data/models/api_response/tele_payment_result_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/network_util.dart';

class EthioTelecomPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final EthioTelecomPurchaseProvider ethioTelecomPurchaseProvider;

  const EthioTelecomPurchaseRepository(
      {required this.ethioTelecomPurchaseProvider});

  Future<TelePaymentResultData> purchaseItem(
    int itemId,
    PurchasedItemType purchasedItemType,
  ) async {
    TeleResult? teleResult;
    PaymentErrorResult? paymentErrorResult;

    ///
    teleResult = null;
    paymentErrorResult = null;

    Response response = await ethioTelecomPurchaseProvider.purchaseItem(
      itemId,
      purchasedItemType,
    );

    ///PARSE TELE RESULT DATA
    if (response.data['tele_response'] != null) {
      teleResult = TeleResult.fromJson(response.data['tele_response']);
    }

    ///PARSE PAYMENT RESULT RESULT DATA
    if (response.data['error_response'] != null) {
      paymentErrorResult =
          PaymentErrorResult.fromJson(response.data['error_response']);
    }

    return TelePaymentResultData(
      paymentErrorResult: paymentErrorResult,
      teleResult: teleResult,
    );
  }

  Future<bool> checkInternetConnection() async {
    bool isInternetAvailable = await NetworkUtil.isInternetAvailable();
    return isInternetAvailable;
  }

  cancelDio() {
    ethioTelecomPurchaseProvider.cancel();
  }
}
