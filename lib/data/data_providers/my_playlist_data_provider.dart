import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/util/api_util.dart';

class MyPlaylistDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  Future<Response> postMyPlaylist(
    File playlistImage,
    String playlistName,
    String playlistDescription,
  ) async {
    dio = Dio();

    ///SEND REQUEST

    ///CHECK IF IMAGE EXISTS
    bool imageExists = playlistImage.existsSync();

    Map<String, dynamic> map = {
      'playlist_name': playlistName,
      'playlist_description': playlistDescription,
    };

    if (imageExists) {
      map['playlist_image'] = await MultipartFile.fromFile(playlistImage.path,
          filename: playlistImage.path.split('/').last);
    }

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    print("FormData.fromMap(map) ${map}");

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.musicBaseUrl + "/user_create_playlist/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  //GET RAW DATA FOR MY PLAYLIST PAGE
  Future getRawMyPlaylistData(AppCacheStrategy appCacheStrategy) async {
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
        url: AppApi.musicBaseUrl + "/user_playlists",
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
        url: AppApi.musicBaseUrl + "/user_playlists",
      );
      return response;
    }
  }

  cancel() {
    print("myPlaylistRepositoryyyy called dio 1");
    if (dio != null) {
      print("myPlaylistRepositoryyyy called dio 2");
      dio.close(force: true);
    }
  }
}
