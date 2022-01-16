import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/payment_provider.dart';
import 'package:mehaley/data/models/api_response/purchase_item_status_data.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/wallet_gift.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/util/api_util.dart';

class PaymentRepository {
  //INIT PROVIDER FOR API CALL
  final PaymentProvider paymentProvider;

  const PaymentRepository({required this.paymentProvider});

  AppPaymentMethods setPreferredPaymentMethod(
      AppPaymentMethods appPaymentMethod) {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.preferredPaymentMethodKey,
      appPaymentMethod,
    );
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  AppPaymentMethods getPreferredPaymentMethod() {
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  Future<PurchaseItemStatusData> checkPurchaseItemStatus(
      int itemId, PurchasedItemType purchasedItemType) async {
    final bool isAlreadyPurchased;
    final bool isFree;
    final double balance;
    final double priceEtb;
    final double priceDollar;
    final List<WalletGift> freshWalletGifts;
    final WebirrBill? freshBill;

    Response response = await paymentProvider.checkPurchaseItemStatus(
        itemId, purchasedItemType);

    //PARSE IS ALREADY PURCHASED
    isAlreadyPurchased =
        response.data['is_already_purchased'] == 1 ? true : false;

    //PARSE IS FREE
    isFree = response.data['is_free'] == 1 ? true : false;

    freshWalletGifts = (response.data['fresh_gift'] as List)
        .map((walletGift) => WalletGift.fromMap(walletGift))
        .toList();

    //PARSE FRESH BILL
    freshBill = response.data['fresh_bill'] != null
        ? WebirrBill.fromMap(response.data['fresh_bill'])
        : null;

    //PARSE CURRENT BALANCE
    balance = response.data['balance'];

    //PARSE PRICE IN ETB
    priceEtb = response.data['price_etb'];

    //PARSE PRICE IN DOLLAR
    priceDollar = response.data['price_dollar'];

    PurchaseItemStatusData purchaseItemStatusData = PurchaseItemStatusData(
      isAlreadyPurchased: isAlreadyPurchased,
      isFree: isFree,
      balance: balance,
      priceEtb: priceEtb,
      freshBill: freshBill,
      freshWalletGifts: freshWalletGifts,
      priceDollar: priceDollar,
    );

    return purchaseItemStatusData;
  }

  Future<Response> purchaseItem(
      int itemId, PurchasedItemType purchasedItemType) async {
    Response response =
        await paymentProvider.purchaseItem(itemId, purchasedItemType, "adasd");

    if (response.statusCode == 200) {
      return response;
    }

    throw "UNABLE TO COMPLETE ITEM PURCHASE";
  }

  Future<void> clearHomePageCache() async {
    await ApiUtil.deleteFromCache(AppApi.musicBaseUrl + "/home-api/", true);
  }

  Future<void> clearWalletPageCache() async {
    await ApiUtil.deleteFromCache("WALLET_PAGES_API_CACHE_KEY", false);
  }

  Future<void> clearLibraryPurchasedSongsCache() async {
    await ApiUtil.deleteFromCache(
        AppApi.paymentBaseUrl + "/purchased/song/all/", true);
    await ApiUtil.deleteFromCache(
        AppApi.paymentBaseUrl + "/purchased/song/", true);
  }

  Future<void> clearLibraryPurchasedAlbumsCache() async {
    await ApiUtil.deleteFromCache(
      AppApi.paymentBaseUrl + "/purchased/album/",
      true,
    );
  }

  Future<void> clearAlbumPageCache(int itemId) async {
    await ApiUtil.deleteFromCache(
      AppApi.musicBaseUrl + "/get-album/?id=$itemId",
      true,
    );
  }

  Future<void> deleteAllCache() async {
    await ApiUtil.deleteAllCache();
  }

  Future<void> clearLibraryPurchasedPlaylistsCache() async {
    await ApiUtil.deleteFromCache(
      AppApi.paymentBaseUrl + "/purchased/playlist/",
      true,
    );
  }

  Future<void> clearPlaylistsPageCache(int itemId) async {
    await ApiUtil.deleteFromCache(
      AppApi.musicBaseUrl + "/get-playlist/?id=$itemId",
      true,
    );
  }

  cancelDio() {
    paymentProvider.cancel();
  }
}
