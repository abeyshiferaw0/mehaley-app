import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/util/api_util.dart';

class LyricDataProvider {
  late Dio? dio;
  final CancelToken cancelToken;

  LyricDataProvider({required this.cancelToken});

  //GET RAW DATA FOR HOME PAGE
  Future getRawLyricData(int songId, AppCacheStrategy appCacheStrategy) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioCacheOptions();
    var timeout = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
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
        dio: dio!,
        url: AppApi.musicBaseUrl + "/get-song-lyrics",
        queryParameters: {'id': songId},
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

      Response response = await ApiUtil.get(
        dio: dio!,
        url: AppApi.musicBaseUrl + "/get-song-lyrics",
        queryParameters: {'id': songId},
        cancelToken: cancelToken,
      );
      return response;
    }
  }

  cancel() {
    print("Request canceled! called");
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('lyric_data_cancelled');
    }
  }
}
