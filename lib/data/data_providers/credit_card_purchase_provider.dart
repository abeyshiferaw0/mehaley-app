import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class CreditCardPurchaseProvider {
  late Dio dio;

  Future generateCheckoutUrl(
    int itemId,
    PurchasedItemType purchasedItemType,
  ) async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.paymentBaseUrl +
          '/purchase/cyber_source/checkout/generate_url/',
      useToken: true,
      data: {
        'item_id': itemId,
        'item_type': EnumToString.convertToString(
          purchasedItemType,
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
