import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/util/api_util.dart';

class DeeplinkSongDataProvider {
  late Dio dio;

  Future getDeepLinkSong(int id) async {
    dio = Dio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/get_song",
      queryParameters: {"id": id},
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
