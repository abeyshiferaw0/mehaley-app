import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/api_util.dart';

class YenepayPurchaseProvider {
  late Dio dio;

  Future generateCheckoutUrl(
    int itemId,
    String itemNameEn,
    double price,
    AppPurchasedItemType appPurchasedItemType,
    String userId,
  ) async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.yenepayPost(
      dio: dio,
      url: AppApi.yenePayGetCheckOutUrl,
      data: jsonEncode({
        'process': YenepayValues.express,
        'merchantOrderId': jsonEncode(
          {
            'user_id': userId,
            'item_id': '$itemId',
            'item_type': EnumToString.convertToString(appPurchasedItemType)
          },
        ),
        'merchantId': YenepayValues.merchantId,
        'items': [
          {
            "itemId": '$itemId',
            "itemName": itemNameEn,
            "unitPrice": price,
            "quantity": 1
          }
        ],
        'successUrl': YenepayValues.successUrl,
        'cancelUrl': YenepayValues.cancelUrl,
        'failureUrl': YenepayValues.failureUrl,
        'ipnUrl': YenepayValues.ipnUrl,
        'expiresAfter': 24
      }),
    );
    return response;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
