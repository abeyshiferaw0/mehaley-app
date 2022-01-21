import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class PaymentProvider {
  late Dio dio;

  Future checkPurchaseItemStatus(
      int itemId, PurchasedItemType purchasedItemType) async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.paymentBaseUrl + "/purchase/status/",
      queryParameters: {
        'item_id': itemId,
        'item_type': EnumToString.convertToString(purchasedItemType),
      },
    );
    return response;
  }

  Future checkOutCart() async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.cartBaseUrl + "/checkout/",
      useToken: true,
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
