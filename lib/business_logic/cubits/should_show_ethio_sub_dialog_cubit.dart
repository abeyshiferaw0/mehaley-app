import 'package:bloc/bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class ShouldShowEthioSubDialogCubit extends Cubit<bool> {
  ShouldShowEthioSubDialogCubit() : super(false);

  checkOnAppStart() async {
    await Future.delayed(Duration(seconds: 2));
    if (isAlienableForDialog()) {
      emit(true);
      emit(false);
    } else {
      emit(false);
    }
  }

  checkOnBottomBarItemClicked() async {
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

    ///CHECK IF Alienable
    if (!isUserSubscribed && isUserPhoneEthiopian && isAuthTypePhoneNumber) {
      return true;
    }
    return false;
  }
}
