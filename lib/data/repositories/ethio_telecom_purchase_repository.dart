import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/ethio_telecom_purchase_provider.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/network_util.dart';

class EthioTelecomPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final EthioTelecomPurchaseProvider ethioTelecomPurchaseProvider;

  const EthioTelecomPurchaseRepository(
      {required this.ethioTelecomPurchaseProvider});

  Future<String> purchaseItem(
    int itemId,
    AppPurchasedItemType appPurchasedItemType,
  ) async {
    Response response = await ethioTelecomPurchaseProvider.purchaseItem(
      itemId,
      appPurchasedItemType,
    );

    print("ETHIOTELECOM  DATA => ${response.data}");
    if (response.statusCode == 200) {
      String checkOutUrl = response.data['payment_url'];
      return checkOutUrl;
    }

    throw "UNABLE TO GENERATE YENE PAY PURCHASE URL";
  }

  Future<bool> checkInternetConnection() async {
    bool isInternetAvailable = await NetworkUtil.isInternetAvailable();
    return isInternetAvailable;
  }

  cancelDio() {
    ethioTelecomPurchaseProvider.cancel();
  }
}
