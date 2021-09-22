import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/app_firebase_user.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/util/api_util.dart';
import 'package:enum_to_string/enum_to_string.dart';

class AuthProvider {
  late Dio dio;

  //GET RAW DATA FOR HOME PAGE
  Future<Response> saveUser(AppFireBaseUser appFireBaseUser) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioCacheOptions();

    dio = Dio();
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
}
