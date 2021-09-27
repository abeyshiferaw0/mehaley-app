import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  // static cancelErrorHandler(Object error) {
  //   if (error is DioError) {
  //     if (CancelToken.isCancel(error)) {
  //       print('Request canceled! ' + error.message);
  //     } else {
  //       throw error;
  //     }
  //   } else {
  //     throw error;
  //   }
  // }

  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("connectivityResultconnectivityResult ${connectivityResult}");
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
