import 'package:dio/dio.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapSubscriptionProvider {
  late Dio dio;

  Future<Map<String, Offering>> fetchOfferings() async {
    ///FETCH ALL OFFERINGS FROM REVENUE CAT
    Offerings offerings = await Purchases.getOfferings();
    // if (offerings.current != null) {
    //   if (offerings.current!.availablePackages.isNotEmpty) {
    //     return offerings.all;
    //   } else {
    //     throw 'IN_APP_SUBSCRIPTIONS_EMPTY_FROM_REVENUE_CAT';
    //   }
    // } else {
    //   throw 'IN_APP_SUBSCRIPTIONS_CURRENT_NOT_FOUND_REVENUE_CAT';
    // }
    if (offerings.all.isNotEmpty) {
      return offerings.all;
    } else {
      throw 'IN_APP_SUBSCRIPTIONS_EMPTY_FROM_REVENUE_CAT';
    }
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
