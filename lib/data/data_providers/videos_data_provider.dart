import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class VideosDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  //GET RAW DATA
  Future getAllVideos(int page, int pageSize) async {
    dio = Dio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/song_video/list/",
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );

    return response;
  }

  //GET RAW DATA
  Future getOtherVideos(AppCacheStrategy appCacheStrategy, int id) async {
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
        url: AppApi.musicBaseUrl + "/song_video/similar/",
        queryParameters: {
          'id': id,
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
        url: AppApi.musicBaseUrl + "/song_video/similar/",
        queryParameters: {
          'id': id,
        },
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
