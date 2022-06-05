import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/iap_purchase_provider.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/network_util.dart';

class IapPurchaseRepository {
  //INIT PROVIDER FOR API CALL
  final IapPurchaseProvider iapPurchaseProvider;

  const IapPurchaseRepository({required this.iapPurchaseProvider});

  Future<bool> checkInternetConnection() async {
    bool isInternetAvailable = await NetworkUtil.isInternetAvailable();
    return isInternetAvailable;
  }

  void getItems() async {}

  Future<void> getAvailablePurchases() async {
    await FlutterInappPurchase.instance.getAvailablePurchases();
  }

  Future<IAPItem> fetchProduct(String itemProductId) async {
    // Set<String> _kIds = <String>{itemProductId};
    // final ProductDetailsResponse response =
    //     await InAppPurchase.instance.queryProductDetails(_kIds);
    // if (response.notFoundIDs.isNotEmpty) {
    //   throw 'fetchProduct ==> Product can not be found';
    // }
    // List<ProductDetails> products = response.productDetails;
    //
    // ///CHECK PRODUCTS LENGTH
    // if (products.length < 1) {
    //   throw 'fetchProduct ==> Product can not be found';
    // }
    //
    // ///CHECK IDS TO BE THE SAME
    // if (products[0].id != itemProductId) {
    //   throw 'fetchProduct ==> Fetched product and itemProductId not the same !==';
    // }
    //
    // return products[0];
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts([itemProductId]);

    if (items.length < 1) {
      throw 'fetchProduct ==> Product can not be found';
    }

    print(
        "event.iapProduct.productId 222 => ${items.length} // ${items.firstWhere((element) => element.productId == itemProductId)}");

    return items.firstWhere((element) => element.productId == itemProductId);
  }

  purchaseProduct(IAPItem iapItem) async {
    // final PurchaseParam purchaseParam = PurchaseParam(
    //   productDetails: productDetails,
    // );
    // await InAppPurchase.instance.buyConsumable(
    //   purchaseParam: purchaseParam,
    // );

    if (iapItem.productId != null) {
      await FlutterInappPurchase.instance.requestPurchase(iapItem.productId!);
    } else {
      throw 'PRODUCT_ID_IS_NULL_FROM_IAP_ITEM';
    }
  }

  setIsIapAvailable(bool isIapAvailable) async {
    ///IF DEVICE IS IOS IGNOR isIapAvailable AND ALWAYS STORE TRUE AVAILABILITY
    if (Platform.isAndroid) {
      await AppHiveBoxes.instance.subscriptionBox
          .put(AppValues.isIapAvailableKey, isIapAvailable);
    } else {
      await AppHiveBoxes.instance.subscriptionBox
          .put(AppValues.isIapAvailableKey, true);
    }
  }

  bool getIsIapAvailable() {
    if (AppHiveBoxes.instance.subscriptionBox
        .containsKey(AppValues.isIapAvailableKey)) {
      return AppHiveBoxes.instance.subscriptionBox
          .get(AppValues.isIapAvailableKey);
    }
    return false;
  }

  saveLastItemToPurchase(PurchasedItemType purchasedItemType, int itemId,
      bool isFromItemSelfPage, AppPurchasedSources appPurchasedSources) async {
    ///SAVE purchasedItemType
    await AppHiveBoxes.instance.iapUtilBox.put(
      AppValues.lastToBePurchasedItemTypeKey,
      EnumToString.convertToString(
        purchasedItemType,
      ),
    );

    ///SAVE purchasedItemType
    await AppHiveBoxes.instance.iapUtilBox.put(
      AppValues.lastToBePurchasedIapPurchasedSourcesKey,
      EnumToString.convertToString(
        appPurchasedSources,
      ),
    );

    ///SAVE itemId
    await AppHiveBoxes.instance.iapUtilBox.put(
      AppValues.lastToBePurchasedItemIdKey,
      itemId,
    );

    ///SAVE itemId
    await AppHiveBoxes.instance.iapUtilBox.put(
      AppValues.lastToBePurchasedIsFromSelfPageKey,
      isFromItemSelfPage,
    );
  }

  Map<String, dynamic> getLastItemToPurchase() {
    Map<String, dynamic> info = {};

    ///GET purchasedItemType
    info[AppValues.lastToBePurchasedItemTypeKey] =
        AppHiveBoxes.instance.iapUtilBox.get(
      AppValues.lastToBePurchasedItemTypeKey,
    );

    ///GET lastToBePurchasedIapPurchasedSourcesKey
    info[AppValues.lastToBePurchasedIapPurchasedSourcesKey] =
        AppHiveBoxes.instance.iapUtilBox.get(
      AppValues.lastToBePurchasedIapPurchasedSourcesKey,
    );

    ///GET itemId
    info[AppValues.lastToBePurchasedItemIdKey] =
        AppHiveBoxes.instance.iapUtilBox.get(
      AppValues.lastToBePurchasedItemIdKey,
    );

    ///GET IS FROM SELF PAGE
    info[AppValues.lastToBePurchasedIsFromSelfPageKey] =
        AppHiveBoxes.instance.iapUtilBox.get(
      AppValues.lastToBePurchasedIsFromSelfPageKey,
    );

    return info;
  }

  Future<bool> verifyItem(int itemId, PurchasedItemType purchasedItemType,
      String purchaseToken) async {
    Response response = await iapPurchaseProvider.verifyItem(
      itemId,
      purchasedItemType,
      purchaseToken,
    );

    print("INAPPPPP USER DATA => ${response.data}");
    if (response.statusCode == 200) {
      bool isValid = response.data['is_valid'] == '1' ? true : false;
      return isValid;
    }

    throw "UNABLE TO COMPLETE ITEM PURCHASE";
  }

  cancelDio() {
    iapPurchaseProvider.cancel();
  }
}
