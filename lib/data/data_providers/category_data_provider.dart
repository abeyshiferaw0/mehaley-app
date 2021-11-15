import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/lyric_item.dart';
import 'package:mehaley/util/api_util.dart';
import 'package:mehaley/util/auth_util.dart';

class CategoryDataProvider {
  //GET RAW DATA FOR CATEGORY PAGE
  late Dio dio;

  //GET RAW DATA FOR HOME PAGE
  Future getRawCategoryTopData(
      int categoryId, AppCacheStrategy appCacheStrategy) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioCacheOptions();

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
        url: AppApi.musicBaseUrl + "/get-categoreies-top",
        queryParameters: {
          'id': categoryId,
        },
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
        url: AppApi.musicBaseUrl + "/get-categoreies-top",
        queryParameters: {
          'id': categoryId,
        },
      );
      return response;
    }
  }

  //GET SONGS FOR CATEGORY
  Future getRawPaginatedSongs(int categoryId, int page, int pageSize) async {
    dio = await AppDio.getDio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/get-categoreies-songs",
      queryParameters: {
        'id': categoryId,
        'page': page,
        'page_size': pageSize,
      },
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
