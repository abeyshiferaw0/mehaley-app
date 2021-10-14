import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/util/api_util.dart';

class CartDataProvider {
  late Dio dio;

  //GET RAW DATA FOR HOME PAGE
  Future getRawCartData(AppCacheStrategy appCacheStrategy) async {
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
        url: AppApi.userBaseUrl + "/cart/",
      );
      return response;
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(policy: CachePolicy.refreshForceCache),
          ),
        );

      Response response = await ApiUtil.get(
        dio: dio,
        url: AppApi.userBaseUrl + "/cart/",
      );
      return response;
    }
  }

  removeSongFromCart(int songId) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'song_id_list[]': songId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/remove_song_cart/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  removeAlbumFromCart(int albumId) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'album_id_list[]': albumId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/remove_album_cart/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  removePlaylistFromCart(int playlistId) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'playlist_id_list[]': playlistId,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/remove_playlist_cart/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  addAlbumToCart(int id) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'album_id_list[]': id,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/add_album_cart/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  addSongToCart(int id) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'song_id_list[]': id,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/add_song_cart/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  addPlaylistToCart(int id) async {
    dio = Dio();

    ///SEND REQUEST
    Map<String, dynamic> map = {
      'playlist_id_list[]': id,
    };

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/add_playlist_cart/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  clearAllCart() async {
    dio = Dio();

    ///SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/cart_clear/",
      useToken: true,
    );

    if (response.statusCode == 200) {
      await ApiUtil.deleteFromCache(AppApi.userBaseUrl + "/cart/");
    }

    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
