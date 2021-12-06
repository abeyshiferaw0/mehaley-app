import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/payment_provider.dart';
import 'package:mehaley/data/models/api_response/purchase_item_status_data.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class PaymentRepository {
  //INIT PROVIDER FOR API CALL
  final PaymentProvider paymentProvider;

  const PaymentRepository({required this.paymentProvider});

  AppPaymentMethods setPreferredPaymentMethod(
      AppPaymentMethods appPaymentMethod) {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.preferredPaymentMethodKey,
      appPaymentMethod,
    );
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  AppPaymentMethods getPreferredPaymentMethod() {
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  Future<PurchaseItemStatusData> checkPurchaseItemStatus(
      int itemId, PurchasedItemType purchasedItemType) async {
    final bool isAlreadyPurchased;
    final bool isFree;
    final double balance;
    final double priceEtb;
    final double priceDollar;

    Response response = await paymentProvider.checkPurchaseItemStatus(
        itemId, purchasedItemType);

    //PARSE IS ALREADY PURCHASED
    isAlreadyPurchased =
        response.data['is_already_purchased'] == 1 ? true : false;

    //PARSE IS FREE
    isFree = response.data['is_free'] == 1 ? true : false;

    //PARSE CURRENT BALANCE
    balance = response.data['balance'];

    //PARSE PRICE IN ETB
    priceEtb = response.data['price_etb'];

    //PARSE PRICE IN DOLLAR
    priceDollar = response.data['price_dollar'];

    PurchaseItemStatusData purchaseItemStatusData = PurchaseItemStatusData(
      isAlreadyPurchased: isAlreadyPurchased,
      isFree: isFree,
      balance: balance,
      priceEtb: priceEtb,
      priceDollar: priceDollar,
    );

    return purchaseItemStatusData;
  }

  cancelDio() {
    paymentProvider.cancel();
  }
}
