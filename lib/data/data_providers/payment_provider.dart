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

  Future checkCartCheckOutStatusData() async {
    dio = Dio();

    //SEND REQUEST
    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.cartBaseUrl + "/payment_status/",
    );
    return response;
  }

  Future purchaseItem(int itemId, PurchasedItemType purchasedItemType) async {
    dio = Dio();

    String url = '';

    if (purchasedItemType == PurchasedItemType.SONG_PAYMENT) {
      url = AppApi.paymentBaseUrl + "/purchase/song/";
    } else if (purchasedItemType == PurchasedItemType.ALBUM_PAYMENT) {
      url = AppApi.paymentBaseUrl + "/purchase/album/";
    } else if (purchasedItemType == PurchasedItemType.PLAYLIST_PAYMENT) {
      url = AppApi.paymentBaseUrl + "/purchase/playlist/";
    } else {
      throw "UNABLE TO PROCESS PAYMENT DUE TO PurchasedItemType NOT ALLOWED ${EnumToString.convertToString(purchasedItemType)}";
    }

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      url: url,
      useToken: true,
      data: {
        'item_id': itemId,
        'payment_type': EnumToString.convertToString(PaymentType.WALLET),
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
