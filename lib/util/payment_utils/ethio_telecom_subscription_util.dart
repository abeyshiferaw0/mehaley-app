import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/subscription/upstream_subscription_page.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class EthioTelecomSubscriptionUtil {
  static bool doesUserSubStatusExists() {
    return AppHiveBoxes.instance.subscriptionBox.containsKey(
      AppValues.localSubscriptionUserStatusKey,
    );
  }

  static Future<void> storeUserLocalSubStatus(
      LocalUserSubscriptionStatus localUserSubscriptionStatus) async {
    await AppHiveBoxes.instance.subscriptionBox.put(
      AppValues.localSubscriptionUserStatusKey,
      EnumToString.convertToString(localUserSubscriptionStatus),
    );
  }

  static LocalUserSubscriptionStatus? getUserSavedLocalSubStatus() {
    if (doesUserSubStatusExists()) {
      return EnumToString.fromString(
        LocalUserSubscriptionStatus.values,
        AppHiveBoxes.instance.subscriptionBox.get(
          AppValues.localSubscriptionUserStatusKey,
        ),
      )!;
    }
    return null;
  }

  static void onTryClicked(context, ethioTeleSubscriptionOfferings) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      await Navigator.of(context).push(
        PagesUtilFunctions.createBottomToUpAnimatedRoute(
          page: UpstreamSubscriptionPage(
            ethioTeleSubscriptionOfferings: ethioTeleSubscriptionOfferings,
          ),
        ),
      );
    } else if (connectivityResult == ConnectivityResult.wifi) {
      PagesUtilFunctions.ethioTelecomSubscribeClicked(
        ethioTeleSubscriptionOfferings,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        buildAppSnackBar(
          bgColor: ColorMapper.getBlack().withOpacity(0.9),
          isFloating: true,
          duration: Duration(seconds: 10),
          msg: 'Please, Try Restarting App After Sending \'Ok\'\nTo Short Code',
          txtColor: ColorMapper.getWhite(),
        ),
      );
    } else {
      PagesUtilFunctions.ethioTelecomSubscribeClicked(
        ethioTeleSubscriptionOfferings,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        buildAppSnackBar(
          bgColor: ColorMapper.getBlack().withOpacity(0.9),
          isFloating: true,
          duration: Duration(seconds: 10),
          msg: 'Please, Try Restarting App After Sending \'Ok\'\nTo Short Code',
          txtColor: ColorMapper.getWhite(),
        ),
      );
    }
  }

  static bool isUrlRedirectToSms(String returnUrl) {
    print('ETHIO SUB TEST => yyyyy ${returnUrl.contains('error')}   ');

    if (returnUrl.contains('error')) {
      return true;
    }
    return false;
  }

  static bool isUrlSubscriptionSuccess(String returnUrl) {
    if (returnUrl.contains('mehaleye.com')) {
      return true;
    }
    return false;
  }
}
