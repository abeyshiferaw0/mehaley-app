import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class AppVersionUtil {
  static Future<bool> isAppBelowMinVersion() async {
    bool isAppBelowMinVersion = false;

    String currentAppVersion = await PagesUtilFunctions.getAppVersionNumber();
    bool exists = AppHiveBoxes.instance.systemUpdate
        .containsKey(AppValues.minAppVersionKey);

    if (exists) {
      String minAppVersion = AppHiveBoxes.instance.systemUpdate.get(
        AppValues.minAppVersionKey,
      );

      ///IF APP VERSION IS BELOW MINIMUM MAKE isAppBelowMinVersion TRUE
      if (minAppVersion.getExtendedVersionNumber() >
          currentAppVersion.getExtendedVersionNumber()) {
        isAppBelowMinVersion = true;
      }
    }

    return isAppBelowMinVersion;
  }

  static String getNewVersion() {
    String minAppVersion = "0.0.0";
    bool exists = AppHiveBoxes.instance.systemUpdate
        .containsKey(AppValues.minAppVersionKey);

    if (exists) {
      minAppVersion = AppHiveBoxes.instance.systemUpdate.get(
        AppValues.minAppVersionKey,
      );
    }
    return minAppVersion;
  }

  static Future<String> getCurrentVersion() async {
    String currentAppVersion = await PagesUtilFunctions.getAppVersionNumber();

    return currentAppVersion;
  }
}
