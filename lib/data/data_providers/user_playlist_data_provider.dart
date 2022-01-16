import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/util/api_util.dart';

class UserPlaylistDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  Future<Response> postUserPlaylist(
    File playlistImage,
    String playlistName,
    String playlistDescription,
    bool createWithSong,
    Song? song,
  ) async {
    dio = Dio();

    ///SEND REQUEST

    ///CHECK IF IMAGE EXISTS
    bool imageExists = playlistImage.existsSync();

    Map<String, dynamic> map = {
      'playlist_name': playlistName,
      'playlist_description': playlistDescription,
    };

    ///CHECK IF CREATE WITH SONG
    if (createWithSong) {
      map['song_id'] = song!.songId;
    }

    ///CHECK IF IMAGE IS PICKED
    if (imageExists) {
      map['playlist_image'] = await MultipartFile.fromFile(playlistImage.path,
          filename: playlistImage.path.split('/').last);
    }

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/playlist_create/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  Future<Response> addSongUserPlaylist(
    MyPlaylist myPlaylist,
    Song song,
  ) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'song_id_list[]': song.songId,
      'playlist_id': myPlaylist.playlistId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/playlist_add_songs/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  removeSongUserPlaylist(MyPlaylist myPlaylist, Song song) async {
    dio = Dio();
    print('playlist_remove_songs');

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'song_id_list[]': song.songId,
      'playlist_id': myPlaylist.playlistId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/playlist_remove_songs/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  //GET RAW DATA
  Future getRawUserPlaylistData(
      int playlistId, AppCacheStrategy appCacheStrategy) async {
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
        url: AppApi.userBaseUrl + "/get_playlist/",
        queryParameters: {'playlist_id': playlistId},
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
        url: AppApi.userBaseUrl + "/get_playlist/",
        queryParameters: {'playlist_id': playlistId},
      );

      return response;
    }
  }

  Future<Response> updateUserPlaylist(int playlistId, String playlistName,
      String playlistDescription, File playlistImage, bool imageRemoved) async {
    dio = Dio();

    ///SEND REQUEST

    ///CHECK IF IMAGE EXISTS
    bool imageExists = playlistImage.existsSync();

    Map<String, dynamic> map = {
      'playlist_id': playlistId,
      'playlist_name': playlistName,
      'is_playlist_image_removed': imageRemoved,
      'playlist_description': playlistDescription,
    };

    ///CHECK IF IMAGE IS PICKED
    if (imageExists) {
      map['playlist_image'] = await MultipartFile.fromFile(playlistImage.path,
          filename: playlistImage.path.split('/').last);
    }

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/update_playlist/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  Future<Response> deletePlaylist(MyPlaylist myPlaylist) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'playlist_id': myPlaylist.playlistId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/delete_playlist/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
