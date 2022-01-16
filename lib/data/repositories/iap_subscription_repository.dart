import 'dart:convert';

import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/iap_subscription_provider.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/util/api_util.dart';
import 'package:mehaley/util/network_util.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapSubscriptionRepository {
  //INIT PROVIDER FOR API CALL
  final IapSubscriptionProvider iapSubscriptionProvider;

  const IapSubscriptionRepository({required this.iapSubscriptionProvider});

  Future<bool> checkInternetConnection() async {
    bool isInternetAvailable = await NetworkUtil.isInternetAvailable();
    return isInternetAvailable;
  }

  Future<void> deleteAllCache() async {
    await ApiUtil.deleteAllCache();
  }

  Future<List<SubscriptionOfferings>> fetchOfferings() async {
    List<SubscriptionOfferings> subscriptionOfferingsList = [];

    ///FETCH ALL OFFERINGS
    Map<String, Offering> offeringsMap =
        await iapSubscriptionProvider.fetchOfferings();

    ///TURN MAP OFFERINGS FROM REVENUE CAT TO LIST
    offeringsMap.forEach(
      (key, value) {
        subscriptionOfferingsList.add(
          SubscriptionOfferings.fromJson(
            json.decode(value.serverDescription),
            value,
          ),
        );
      },
    );
    return subscriptionOfferingsList;
  }

  Future<PurchaserInfo> purchaseSubscription(Offering offering) async {
    PurchaserInfo purchaserInfo = await Purchases.purchasePackage(
      offering.availablePackages[0],
    );
    return purchaserInfo;
  }

  Future<PurchaserInfo> restorePurchase() async {
    PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
    return restoredInfo;
  }

  setUserIsSubscribes(bool isSubscribed) async {
    await AppHiveBoxes.instance.subscriptionBox
        .put(AppValues.isSubscribedKey, isSubscribed);
  }

  bool getUserIsSubscribes() {
    if (AppHiveBoxes.instance.subscriptionBox
        .containsKey(AppValues.isSubscribedKey)) {
      return AppHiveBoxes.instance.subscriptionBox
          .get(AppValues.isSubscribedKey);
    }
    return false;
  }

  Future<PurchaserInfo> checkIapSubscription() async {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    return purchaserInfo;
  }

  cancelDio() {
    iapSubscriptionProvider.cancel();
  }
}
