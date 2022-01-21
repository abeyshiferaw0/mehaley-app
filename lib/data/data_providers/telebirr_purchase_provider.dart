import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class TelebirrPurchaseProvider {
  late Dio dio;

  Future generateCheckoutUrl(
    int itemId,
    AppPurchasedItemType appPurchasedItemType,
  ) async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.paymentBaseUrl + '/purchase/telebirr/checkout/generate_url/',
      useToken: true,
      data: {
        'item_id': itemId,
        'item_type': EnumToString.convertToString(
          appPurchasedItemType,
        ),
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
