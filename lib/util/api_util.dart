import 'package:dio/dio.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:hive/hive.dart';

class ApiUtil {
  static Future<Response> get({
    required Dio dio,
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    ///GET USER TOKE
    String token = AppHiveBoxes.instance.userBox.get(AppValues.userAccessTokenKey);

    ///CONFIG HEADER
    Options options = Options(headers: {"Authorization": "Token $token"});

    var response = await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
    );

    return response;
  }

  static Future<Response> post({
    required Dio dio,
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required bool useToken,
  }) async {
    ///INIT OPTIONS
    Options? options;

    if (useToken) {
      ///GET USER TOKEN AND CSRF TOKEN
      String token = AppHiveBoxes.instance.userBox.get(AppValues.userAccessTokenKey);

      ///CONFIG HEADER TOKEN
      options = Options(
        headers: {
          "Authorization": "Token $token",
          "content-type": "application/x-www-form-urlencoded"
        },
      );
    }
    var response = await dio.post(
      url,
      data: data,
      options: useToken ? options : null,
      queryParameters: queryParameters,
    );

    return response;
  }
}
