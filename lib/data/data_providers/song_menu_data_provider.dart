import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/util/api_util.dart';

class SongMenuDataProvider {
  late Dio dio;

  Future getSongLeftOverData(int id) async {
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    //SEND REQUEST
    dio = Dio(options);

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.musicBaseUrl + "/get-song-menu/",
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
