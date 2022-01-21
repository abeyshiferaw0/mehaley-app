import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class IapPurchaseProvider {
  late Dio dio;

  Future verifyItem(
    int itemId,
    AppPurchasedItemType appPurchasedItemType,
    String purchaseToken,
  ) async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: AppApi.paymentBaseUrl + "/purchase/in_app_purchases/",
      useToken: true,
      data: {
        'item_id': itemId,
        'item_type': EnumToString.convertToString(appPurchasedItemType),
        'device': Platform.isAndroid ? 'ANDROID' : 'IOS',
        'token': purchaseToken,
      },
    );
    print("INAPPPPP USER DATA => ${response.data}");
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
