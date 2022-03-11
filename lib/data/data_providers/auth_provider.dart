import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/app_firebase_user.dart';
import 'package:mehaley/util/api_util.dart';

class AuthProvider {
  late Dio dio;

  //GET RAW DATA FOR HOME PAGE
  Future<Response> saveUser(AppFireBaseUser appFireBaseUser) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioCacheOptions();
    BaseOptions options = new BaseOptions(
      connectTimeout: 30000,
      receiveTimeout: 15000,
    );
    dio = Dio(options);
    //SEND REQUEST

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/save_user/",
      useToken: false,
      data: {
        'user_name': appFireBaseUser.userName,
        'user_email': appFireBaseUser.email,
        'phone_number_country_code': appFireBaseUser.phoneNumberCountryCode,
        'phone_number': appFireBaseUser.phoneNumber,
        'social_profile_img_url': appFireBaseUser.socialProfileImgUrl,
        'auth_login_id': appFireBaseUser.authLoginId,
        'login_type': EnumToString.convertToString(appFireBaseUser.loginType),
      },
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }

  updateUser(String userName, File image, bool imageChanged) async {
    dio = Dio();

    ///SEND REQUEST

    ///CHECK IF IMAGE EXISTS
    bool imageExists = image.existsSync();

    Map<String, dynamic> map = {
      'user_name': userName,
      'is_profile_image_removed': imageChanged,
    };

    ///CHECK IF IMAGE IS PICKED
    if (imageExists) {
      map['profile_image'] = await MultipartFile.fromFile(image.path,
          filename: image.path.split('/').last);
    }

    ///FORM DATA
    FormData formData = FormData.fromMap(map);

    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.userBaseUrl + "/update_profile/",
      useToken: true,
      data: formData,
    );
    return response;
  }

  clearDioCache() async {
    await ApiUtil.deleteAllCache();
  }
}
