import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class EthioTelecomSubscriptionProvider {
  late Dio dio;

  Future getEthioTeleSubscriptionOfferings(
      AppCacheStrategy appCacheStrategy) async {
    dio = Dio();

    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioCacheOptions();
    var timeout = BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 60000,
    );
    if (appCacheStrategy == AppCacheStrategy.LOAD_CACHE_FIRST) {
      //INIT DIO WITH CACHE OPTION FORCE CACHE
      dio = Dio(timeout)
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(policy: CachePolicy.forceCache),
          ),
        );

      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: AppApi.userBaseUrl + '/subscription/local/option/',
      );
      return response;
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio(timeout)
        ..interceptors.add(
          DioCacheInterceptor(
            options:
                cacheOptions.copyWith(policy: CachePolicy.refreshForceCache),
          ),
        );

      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: AppApi.userBaseUrl + '/subscription/local/option/',
      );
      return response;
    }

    //return """[{"title_en":"Daily Subscription","title_am":"Daily Subscription","description_en":"Get access to Unlimited streaming and download with Meleket daily subscription","description_am":"Get access to Unlimited streaming and download with Meleket daily subscription","shortCode":"8080","shortCodeSubscribeTxt":"ok","priceDescription_en":"3 days freeThen 2 birr/day","priceDescription_am":"3 days freeThen 2 birr/day","savingDescription_en":"","savingDescription_am":"","subTitle_en":"No Commitment, cancel at any time","subTitle_am":"No Commitment, cancel at any time","textColor":"#ffffff","color1":"#3CB5AC","color2":"#4674E7","color3":"#845AE8"}]""";
  }

  LocalUserSubscriptionStatus getLocalSubscriptionStatus() {
    return EnumToString.fromString(
      LocalUserSubscriptionStatus.values,
      AppHiveBoxes.instance.subscriptionBox.get(
        AppValues.localSubscriptionUserStatusKey,
      ),
    )!;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
