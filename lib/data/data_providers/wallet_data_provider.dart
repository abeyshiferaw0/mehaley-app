import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/util/api_util.dart';

class WalletDataProvider {
  late Dio dio;
  String walletPageMainUrl = AppApi.paymentBaseUrl + "/wallet/";

  //GET RAW DATA FOR WALLET PAGE
  Future getWalletData(AppCacheStrategy appCacheStrategy) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    if (appCacheStrategy == AppCacheStrategy.LOAD_CACHE_FIRST) {
      //INIT DIO WITH CACHE OPTION FORCE CACHE
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(policy: CachePolicy.forceCache),
          ),
        );
      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: walletPageMainUrl,
      );
      return response;
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(
              policy: CachePolicy.refreshForceCache,
            ),
          ),
        );

      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: walletPageMainUrl,
      );
      return response;
    }
  }

  Future checkBillStatus() async {
    BaseOptions options = new BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 9000,
    );
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    ///ADD TIME OUT TO REQUEST
    dio = Dio(options)
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(
            policy: CachePolicy.refreshForceCache,
          ),
        ),
      );

    //SEND REQUEST
    Response response = await ApiUtil.get(
      dio: dio,
      url: walletPageMainUrl,
    );
    return response;
  }

  Future cancelBill() async {
    BaseOptions options = new BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 9000,
    );
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    ///ADD TIME OUT TO REQUEST
    dio = Dio(options)
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(
            policy: CachePolicy.refreshForceCache,
          ),
        ),
      );

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      useToken: true,
      url: AppApi.paymentBaseUrl + "/wallet/bill/cancel/",
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
