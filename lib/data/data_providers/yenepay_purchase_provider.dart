import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class YenepayPurchaseProvider {
  late Dio dio;

  Future generateCheckoutUrl(
    int itemId,
    AppPurchasedItemType appPurchasedItemType,
    AppPurchasedSources appPurchasedSources,
    bool isFromSelfPage,
  ) async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.paymentBaseUrl + '/purchase/yene_pay/checkout/generate_url/',
      useToken: true,
      data: {
        'item_id': itemId,
        'item_type': EnumToString.convertToString(
          appPurchasedItemType,
        ),
        'app_purchased_sources': EnumToString.convertToString(
          appPurchasedSources,
        ),
        'is_from_self_page': isFromSelfPage,
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
