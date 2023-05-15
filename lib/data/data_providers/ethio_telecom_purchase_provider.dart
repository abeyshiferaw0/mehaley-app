import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class EthioTelecomPurchaseProvider {
  late Dio dio;

  Future purchaseItem(
    int itemId,
    PurchasedItemType purchasedItemType,
  ) async {
    dio = Dio();
    print("responseee => ${itemId}");
    print("responseee => ${EnumToString.convertToString(
      purchasedItemType,
    )}");
    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.paymentBaseUrl + '/purchase/tele_mobile/checkout/',
      useToken: true,
      data: {
        'item_id': itemId,
        'item_type': EnumToString.convertToString(
          purchasedItemType,
        ),
      },
    );
    print("responseee => ${response.data}");
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
