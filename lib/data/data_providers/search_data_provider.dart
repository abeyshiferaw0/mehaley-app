import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class SearchDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  //GET RAW DATA FOR SEARCH FRONT PAGE
  Future getRawSearchFrontData(AppCacheStrategy appCacheStrategy) async {
    //GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();

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
        url: AppApi.musicBaseUrl + "/search-page/",
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
        url: AppApi.musicBaseUrl + "/search-page/",
      );
      return response;
    }
  }

  Future getSearchResult(
      String key, CancelToken searchResultCancelToken) async {
    //GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();

    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );
    //SEND REQUEST
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/search/",
      queryParameters: {"query": key},
    );
    return response;
  }

  Future getDedicatedSearchResult(
      String key, AppSearchItemTypes appSearchItemTypes) async {
    //GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();

    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );
    //SEND REQUEST
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + getAppSearchItemTypes(appSearchItemTypes),
      queryParameters: {"query": key},
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }

  String getAppSearchItemTypes(AppSearchItemTypes appSearchItemTypes) {
    if (appSearchItemTypes == AppSearchItemTypes.ARTIST) {
      return "/search-all-artist/";
    } else if (appSearchItemTypes == AppSearchItemTypes.ALBUM) {
      return "/search-all-album/";
    } else if (appSearchItemTypes == AppSearchItemTypes.PLAYLIST) {
      return "/search-all-playlist/";
    } else {
      return "/search-all-song/";
    }
  }
}
