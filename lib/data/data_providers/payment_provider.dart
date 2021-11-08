import 'package:dio/dio.dart';

class PaymentProvider {
  late Dio dio;

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
