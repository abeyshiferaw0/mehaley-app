import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/util/api_util.dart';
import 'package:path_provider/path_provider.dart';

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
      url = "/purchased_songs_all";
    } else if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.SONGS) {
      url = "/purchased_songs";
    } else if (appPurchasedPageItemTypes == AppPurchasedPageItemTypes.ALBUMS) {
      url = "/purchased_albums";
    } else if (appPurchasedPageItemTypes ==
        AppPurchasedPageItemTypes.PLAYLISTS) {
      url = "/purchased_playlists";
    } else {
      throw "AppPurchasedPageItemTypes IS INCORRECT";
    }
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.userBaseUrl + url,
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

  deleteCache(String url) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    HiveCacheStore(appDocPath).delete(url);
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
