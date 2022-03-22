import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class AppAdDataProvider {
  late Dio dio;

  //GET RAW DATA FOR ADS
  Future getAppAds(AppCacheStrategy appCacheStrategy) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioCacheOptions();

    if (appCacheStrategy == AppCacheStrategy.LOAD_CACHE_FIRST) {
      //INIT DIO WITH CACHE OPTION FORCE CACHE
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(
              policy: CachePolicy.forceCache,
              maxStale: Nullable(Duration(days: 3)),
            ),
          ),
        );
      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: AppApi.adBaseUrl + "/",
      );
      return response;
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options:
                cacheOptions.copyWith(policy: CachePolicy.refreshForceCache),
          ),
        );
      Response response = await ApiUtil.get(
        dio: dio,
        url: AppApi.adBaseUrl + "/",
      );
      return response;
    }
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
