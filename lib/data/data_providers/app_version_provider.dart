import 'package:dio/dio.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/util/api_util.dart';

class AppVersionProvider {
  late Dio dio;

  //GET RAW DATA FOR HOME PAGE
  Future getMinAppVersion() async {
    dio = Dio();
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.userBaseUrl + "/getAppMinVersion",
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
