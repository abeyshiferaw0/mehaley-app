import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/yenepay_purchase_provider.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class YenepayPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final YenepayPurchaseProvider yenepayPurchaseProvider;

  const YenepayPurchaseRepository({required this.yenepayPurchaseProvider});

  Future<String> generateCheckoutUrl(
    int itemId,
    String itemNameEn,
    double price,
    AppPurchasedItemType appPurchasedItemType,
    String userId,
  ) async {
    Response response = await yenepayPurchaseProvider.generateCheckoutUrl(
      itemId,
      itemNameEn,
      price,
      appPurchasedItemType,
      userId,
    );

    print("YENEPAYYY  DATA => ${response.data}");
    if (response.statusCode == 200) {
      String checkOutUrl = response.data['result'];
      return checkOutUrl;
    }

    throw "UNABLE TO COMPLETE ITEM YENE PAY PURCHASE";
  }

  cancelDio() {
    yenepayPurchaseProvider.cancel();
  }
}
