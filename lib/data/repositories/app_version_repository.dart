import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/app_version_provider.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:new_version/new_version.dart';

class AppVersionRepository {
  //INIT PROVIDER FOR API CALL
  final AppVersionProvider appVersionProvider;

  const AppVersionRepository({required this.appVersionProvider});

  Future<String> getMinAppVersion() async {
    final String minAppVersion;

    Response response = await appVersionProvider.getMinAppVersion();

    //PARSE MIN VERSION
    minAppVersion = response.data['value'];

    return minAppVersion;
  }

  Future<void> saveMinAppVersion(String minVersion) async {
    await AppHiveBoxes.instance.systemUpdate
        .put(AppValues.minAppVersionKey, minVersion);
    return;
  }

  Future<VersionStatus> getVersionStatus() async {
    final newVersion = NewVersion();
    final VersionStatus? status = await newVersion.getVersionStatus();
    if (status == null) {
      throw "ERROR CHECKING NEW VERSION";
    }
    return status;
  }

  Future<bool> isLastNewVersionShownMoreThanWeek() async {
    if (AppHiveBoxes.instance.systemUpdate.containsKey(
      AppValues.lastNewVersionShownDateKey,
    )) {
      ///GET THE NUMBER OF DAYS BETWEEN NOTIFICATION SHOWN
      int preDateInMilliSeconds = AppHiveBoxes.instance.systemUpdate.get(
        AppValues.lastNewVersionShownDateKey,
      );
      DateTime preDateTime = DateTime.fromMillisecondsSinceEpoch(
        preDateInMilliSeconds,
      );
      int diffDays = DateTime.now().difference(preDateTime).inDays;
      return diffDays > 7 ? true : false;
    } else {
      return true;
    }
  }

  Future<bool> isLastShownVersionDiffThanNewVersion(
      VersionStatus versionStatus) async {
    if (AppHiveBoxes.instance.systemUpdate.containsKey(
      AppValues.lastNewVersionShownVersionKey,
    )) {
      ///GET THE LAST SHOWN VERSION NUMBER
      String preVersion = AppHiveBoxes.instance.systemUpdate.get(
        AppValues.lastNewVersionShownVersionKey,
      );
      if (preVersion.getExtendedVersionNumber() ==
          versionStatus.storeVersion.getExtendedVersionNumber()) {
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  Future<bool> isDontAskAgainEnabled(VersionStatus versionStatus) async {
    if (AppHiveBoxes.instance.systemUpdate.containsKey(
      AppValues.newVersionDontAskAgainKey,
    )) {
      ///GET THE NEW VERSION DONT ASK AGAIN ENABLED
      bool dontAskAgain = AppHiveBoxes.instance.systemUpdate.get(
        AppValues.newVersionDontAskAgainKey,
      );

      return dontAskAgain;
    } else {
      return false;
    }
  }

  Future<void> updateNewVersionVariables(
      VersionStatus versionStatus, bool resetDontAkAgain) async {
    ///UPDATE LAST SHOWN DATE
    await AppHiveBoxes.instance.systemUpdate.put(
        AppValues.lastNewVersionShownDateKey,
        DateTime.now().millisecondsSinceEpoch);

    ///UPDATE LAST SHOWN VERSION
    await AppHiveBoxes.instance.systemUpdate.put(
        AppValues.lastNewVersionShownVersionKey, versionStatus.storeVersion);

    if (resetDontAkAgain) {
      ///UPDATE LAST SHOWN VERSION
      await AppHiveBoxes.instance.systemUpdate
          .put(AppValues.newVersionDontAskAgainKey, false);
    }
  }

  cancelDio() {
    appVersionProvider.cancel();
  }
}
