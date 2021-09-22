import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/util/api_util.dart';

class LibraryDataProvider {
  late Dio dio;
  late CacheOptions cacheOptions;

  ///FOR SONG
  Future<Response> likeSong(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/like_song/",
      useToken: true,
      data: {
        'song_id': id,
      },
    );

    return response;
  }

  Future<Response> unlikeSong(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/unlike_song/",
      useToken: true,
      data: {
        'song_id': id,
      },
    );

    return response;
  }

  ///FOR ALBUM
  Future<Response> likeAlbum(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/like_album/",
      useToken: true,
      data: {
        'album_id': id,
      },
    );

    return response;
  }

  Future<Response> unlikeAlbum(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/unlike_album/",
      useToken: true,
      data: {
        'album_id': id,
      },
    );

    return response;
  }

  ///FOR PLAYLIST
  Future<Response> followPlaylist(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/follow_playlist/",
      useToken: true,
      data: {
        'playlist_id': id,
      },
    );

    return response;
  }

  Future<Response> unFollowPlaylist(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/unfollow_playlist/",
      useToken: true,
      data: {
        'playlist_id': id,
      },
    );

    return response;
  }

  ///FOR ARTIST
  Future<Response> followArtist(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/follow_artist/",
      useToken: true,
      data: {
        'artist_id': id,
      },
    );

    return response;
  }

  Future<Response> unFollowArtist(int id) async {
    ///GET CACHE OPTIONS
    cacheOptions = await AppApi.getDioCacheOptions();
    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(policy: CachePolicy.noCache),
        ),
      );

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/unfollow_artist/",
      useToken: true,
      data: {
        'artist_id': id,
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
