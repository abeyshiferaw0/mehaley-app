import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class LibraryPageDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  //GET RAW DATA
  Future getPurchasedItems(AppCacheStrategy appCacheStrategy,
      AppPurchasedPageItemTypes appPurchasedPageItemTypes) async {
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
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options:
                cacheOptions.copyWith(policy: CachePolicy.refreshForceCache),
          ),
        );
    }

    //SEND REQUEST
    String url = "";
    if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALL_SONGS) {
      url = "/purchased/song/all/";
    } else if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.SONGS) {
      url = "/purchased/song/";
    } else if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALBUMS) {
      url = "/purchased/album/";
    } else if (appPurchasedPageItemTypes ==
        AppPurchasedPageItemTypes.PLAYLISTS) {
      url = "/purchased/playlist/";
    } else {
      throw "AppPurchasedPageItemTypes IS INCORRECT";
    }
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.paymentBaseUrl + url,
    );

    return response;
  }

  Future getPurchasedPaginatedAllSongs(int page, int pageSize) async {
    dio = await AppDio.getDio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.paymentBaseUrl + "/purchased/song/all/list/",
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return response;
  }

  Future getFavoriteItems(AppCacheStrategy appCacheStrategy,
      AppFavoritePageItemTypes appFavoritePageItemTypes) async {
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
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options:
                cacheOptions.copyWith(policy: CachePolicy.refreshForceCache),
          ),
        );
    }

    String url = "";
    if (appFavoritePageItemTypes == AppFavoritePageItemTypes.SONGS) {
      url = "/liked_songs";
    } else if (appFavoritePageItemTypes == AppFavoritePageItemTypes.ALBUMS) {
      url = "/liked_albums";
    } else {
      throw "AppFavoritePageItemTypes IS INCORRECT";
    }
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.userBaseUrl + url,
    );

    return response;
  }

  Future getFollowingItems(AppCacheStrategy appCacheStrategy,
      AppFollowedPageItemTypes appFollowedPageItemTypes) async {
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
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options:
                cacheOptions.copyWith(policy: CachePolicy.refreshForceCache),
          ),
        );
    }

    String url = "";
    if (appFollowedPageItemTypes == AppFollowedPageItemTypes.PLAYLISTS) {
      url = "/followed_playlists";
    } else if (appFollowedPageItemTypes == AppFollowedPageItemTypes.ARTIST) {
      url = "/followed_artists";
    } else {
      throw "AppFavoritePageItemTypes IS INCORRECT";
    }
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.userBaseUrl + url,
    );

    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
