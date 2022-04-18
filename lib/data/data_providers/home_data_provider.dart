import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class HomeDataProvider {
  late Dio dio;

  //GET RAW DATA FOR HOME PAGE
  Future getRawHomeData(AppCacheStrategy appCacheStrategy) async {
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
        url: AppApi.musicBaseUrl + "/home-api/",
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
        url: AppApi.musicBaseUrl + "/home-api/",
      );
      return response;
    }
  }

  Future getPaginatedAllSongs(int page, int pageSize) async {
    dio = await AppDio.getDio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/items/song/",
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return response;
  }

  Future getPaginatedAllAlbums(int page, int pageSize) async {
    dio = await AppDio.getDio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/items/album/",
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return response;
  }

  Future getPaginatedAllArtists(int page, int pageSize) async {
    dio = await AppDio.getDio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/items/artist/",
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return response;
  }

  Future getPaginatedAllPlaylists(int page, int pageSize) async {
    dio = await AppDio.getDio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/items/playlist/",
      queryParameters: {
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
