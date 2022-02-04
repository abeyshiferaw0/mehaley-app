import 'package:mehaley/data/data_providers/app_ad_data_provider.dart';
import 'package:mehaley/data/models/api_response/app_ad_data.dart';
import 'package:mehaley/data/models/app_ad.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class AppAdDataRepository {
  //INIT PROVIDER FOR API CALL
  final AppAdDataProvider appAdDataProvider;

  const AppAdDataRepository({required this.appAdDataProvider});

  Future<AppAdData> getAppAds(AppCacheStrategy appCacheStrategy) async {
    final List<AppAd> appAdList;

    var response = await appAdDataProvider.getAppAds(appCacheStrategy);

    //PARSE APP ADS LIST
    appAdList = (response.data as List).map((ad) => AppAd.fromMap(ad)).toList();

    AppAdData appAdData = AppAdData(
      appAdList: appAdList,
      response: response,
    );

    return appAdData;
  }

  cancelDio() {
    appAdDataProvider.cancel();
  }
}
