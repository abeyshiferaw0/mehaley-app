import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/yenepay_purchase_provider.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class YenepayPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final YenepayPurchaseProvider yenepayPurchaseProvider;

  const YenepayPurchaseRepository({required this.yenepayPurchaseProvider});

  Future<String> generateCheckoutUrl(
    int itemId,
    PurchasedItemType purchasedItemType,
    AppPurchasedSources appPurchasedSources,
    bool isFromSelfPage,
  ) async {
    Response response = await yenepayPurchaseProvider.generateCheckoutUrl(
      itemId,
      purchasedItemType,
      appPurchasedSources,
      isFromSelfPage,
    );

    print("YENEPAYYY  DATA => ${response.data}");
    if (response.statusCode == 200) {
      String checkOutUrl = response.data['payment_url'];
      return checkOutUrl;
    }

    throw "UNABLE TO GENERATE YENE PAY PURCHASE URL";
  }

  cancelDio() {
    yenepayPurchaseProvider.cancel();
  }
}
