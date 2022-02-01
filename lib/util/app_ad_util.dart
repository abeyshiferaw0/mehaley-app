import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/app_ad.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class AppAdUtil {
  static AppAd? getAppAdForHomePage(List<AppAd> appAdList) {
    AppAd? appAd;
    appAd = appAdList.firstWhere(
      (element) => element.appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE,
    );

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
      int diffDays = DateTime.now().difference(preDateTime).inDays;
      return diffDays > 2 ? true : false;
    } else {
      return true;
    }
  }

  static AppAd? getAppAdForPlayerPage(List<AppAd> appAdList) {
    AppAd? appAd;
    appAd = appAdList.firstWhere(
      (element) =>
          element.appAddEmbedPlace == AppAddEmbedPlace.PLAYER_PAGE_ALBUM_ART,
    );

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
