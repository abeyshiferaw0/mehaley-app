import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/ethio_telecom_subscription_provider.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/ethio_tele_subscription_offerings.dart';
import 'package:mehaley/util/payment_utils/ethio_telecom_subscription_util.dart';

class EthioTelecomSubscriptionRepository {
  //INIT PROVIDER FOR API CALL
  final EthioTelecomSubscriptionProvider ethioTelecomSubscriptionProvider;

  const EthioTelecomSubscriptionRepository(
      {required this.ethioTelecomSubscriptionProvider});

  Future<List<EthioTeleSubscriptionOfferings>>
  getEthioTeleSubscriptionOfferings(AppCacheStrategy appCacheStrategy,) async {
    final List<EthioTeleSubscriptionOfferings> subscriptionOfferingsList;

    Response response = await ethioTelecomSubscriptionProvider
        .getEthioTeleSubscriptionOfferings(appCacheStrategy);

    print("response.data ${response.data}");

    //PARSE SUBSCRIPTION OFFERINGS
    subscriptionOfferingsList = (response.data as List)
        .map((offering) => EthioTeleSubscriptionOfferings.fromJson(offering))
        .toList();

    return subscriptionOfferingsList;
  }

  LocalUserSubscriptionStatus getLocalSubscriptionStatus() {
    return ethioTelecomSubscriptionProvider.getLocalSubscriptionStatus();
  }


  bool isLocallySubscribed() {
    LocalUserSubscriptionStatus? nowStatus = EthioTelecomSubscriptionUtil
        .getUserSavedLocalSubStatus();

    if (nowStatus == LocalUserSubscriptionStatus.RENEWED ||
        nowStatus == LocalUserSubscriptionStatus.ACTIVE) {
      return true;
    } else {
      return false;
    }
  }

  cancelDio() {
    ethioTelecomSubscriptionProvider.cancel();
  }

}
