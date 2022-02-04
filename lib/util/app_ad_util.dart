import 'package:collection/src/iterable_extensions.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/app_ad.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class AppAdUtil {
  static AppAd? getAppAdForHomePage(
      List<AppAd> appAdList, AppAddEmbedPlace appAddEmbedPlace) {
    AppAd? appAd;

    if (appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_TOP) {
      appAd = appAdList.firstWhereOrNull(
        (element) => element.appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_TOP,
      );
    } else if (appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_MIDDLE) {
      appAd = appAdList.firstWhereOrNull(
        (element) =>
            element.appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_MIDDLE,
      );
    } else if (appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_BOTTOM) {
      appAd = appAdList.firstWhereOrNull(
        (element) =>
            element.appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_BOTTOM,
      );
    } else {
      return null;
    }

    return appAd;
  }

  static adRecentlyShown() async {
    await AppHiveBoxes.instance.recentlyAdShownBox.put(
      AppValues.recentlyPlayerAdShownTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static bool isPlayerAdShownRecently() {
    if (isLastPlayerAdShownMoreThan2Days()) {
      return false;
    }
    return true;
  }

  static bool isLastPlayerAdShownMoreThan2Days() {
    if (AppHiveBoxes.instance.recentlyAdShownBox.containsKey(
      AppValues.recentlyPlayerAdShownTimeKey,
    )) {
      ///GET THE NUMBER OF DAYS BETWEEN
      int preDateInMilliSeconds = AppHiveBoxes.instance.recentlyAdShownBox.get(
        AppValues.recentlyPlayerAdShownTimeKey,
      );
      DateTime preDateTime = DateTime.fromMillisecondsSinceEpoch(
        preDateInMilliSeconds,
      );
      int diffDays = DateTime.now().difference(preDateTime).inHours;
      return diffDays > 48 ? true : false;
    } else {
      return true;
    }
  }

  static AppAd? getAppAdForPlayerPage(List<AppAd> appAdList) {
    AppAd? appAd;
    appAd = appAdList.firstWhereOrNull(
      (element) =>
          element.appAddEmbedPlace == AppAddEmbedPlace.PLAYER_PAGE_ALBUM_ART,
    );
    print("appAdappAd ${appAd}");
    return appAd;
  }

  static Future<void> call(String phoneNumber) async {
    bool result = await canLaunch('tel:$phoneNumber}');
    if (result) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launch(launchUri.toString());
    } else {
      print("call(String phoneNumber) false");
    }
  }

  static Future<void> launchInBrowser(String url) async {
    try {
      if (!await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {}
  }

  static void remove() {
    AppHiveBoxes.instance.recentlyAdShownBox.delete(
      AppValues.recentlyPlayerAdShownTimeKey,
    );
  }
}
