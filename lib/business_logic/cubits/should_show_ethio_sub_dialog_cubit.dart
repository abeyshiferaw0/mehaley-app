import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

import '../../util/payment_utils/ethio_telecom_subscription_util.dart';

class ShouldShowEthioSubDialogCubit extends Cubit<bool> {
  ShouldShowEthioSubDialogCubit() : super(false);

  checkOnAppStart() async {
    print("ShouldShowEthioSubDialogCubit checkOnAppStart");
    await Future.delayed(Duration(seconds: 2));
    if (isAlienableForDialog()) {
      emit(true);
      emit(false);
    } else {
      emit(false);
    }
  }

  checkOnBottomBarItemClicked() async {
    print("ShouldShowEthioSubDialogCubit checkOnBottomBarItemClicked");
    int bottomClickCount = AppHiveBoxes.instance.settingsBox
        .get(AppValues.bottomBarClickedCountKey);

    await AppHiveBoxes.instance.settingsBox
        .put(AppValues.bottomBarClickedCountKey, bottomClickCount + 1);

    bottomClickCount = AppHiveBoxes.instance.settingsBox
        .get(AppValues.bottomBarClickedCountKey);

    if (bottomClickCount > 6) {
      await AppHiveBoxes.instance.settingsBox
          .put(AppValues.bottomBarClickedCountKey, 0);
    }

    if (isAlienableForDialog() && bottomClickCount > 5) {
      await AppHiveBoxes.instance.settingsBox
          .put(AppValues.bottomBarClickedCountKey, 0);

      emit(true);
      emit(false);
    } else {
      emit(false);
    }
  }

  checkOnPlayingUnPurchasedSong() async {
    print("ShouldShowEthioSubDialogCubit checkOnPlayingUnPurchasedSong");
    if (isAlienableForDialog()) {
      emit(true);
      emit(false);
    } else {
      emit(false);
    }
  }

  bool isAlienableForDialog() {
    ///GET BOOL VALUES
    bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
    bool isUserPhoneEthiopian = AuthUtil.isUserPhoneEthiopian();
    bool isAuthTypePhoneNumber = AuthUtil.isAuthTypePhoneNumber();

    ///GET CURRENT ETHIO TELECOM
    LocalUserSubscriptionStatus? nowStatus =
        EthioTelecomSubscriptionUtil.getUserSavedLocalSubStatus();

    ///CHECK IF Alienable
    if (!isUserSubscribed && isUserPhoneEthiopian && isAuthTypePhoneNumber) {
      ///THIS CONDITION ADDED TO NOT SHOW DIALOG
      ///WHEN FIRST TIME INSTALLATION WHILE BEING ETHIO TEL SUBSCRIBE
      print("nowStatus=>>> ${EnumToString.convertToString(nowStatus)}");

      if (nowStatus != LocalUserSubscriptionStatus.ACTIVATION_PENDING) {
        return true;
      }
    }
    return false;
  }
}
