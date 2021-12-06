import "package:collection/collection.dart";
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/wallet_history.dart';
import 'package:mehaley/data/models/payment/wallet_history_group.dart';
import 'package:mehaley/util/api_util.dart';

class WalletDataProvider {
  late Dio dio;
  String walletPageMainUrl = AppApi.paymentBaseUrl + "/wallet/";

  //GET RAW DATA FOR WALLET PAGE
  Future getWalletData(AppCacheStrategy appCacheStrategy) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    if (appCacheStrategy == AppCacheStrategy.LOAD_CACHE_FIRST) {
      //INIT DIO WITH CACHE OPTION FORCE CACHE
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(policy: CachePolicy.forceCache),
          ),
        );
      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: walletPageMainUrl,
      );
      return response;
    } else if (appCacheStrategy == AppCacheStrategy.CACHE_LATER) {
      dio = Dio()
        ..interceptors.add(
          DioCacheInterceptor(
            options: cacheOptions.copyWith(
              policy: CachePolicy.refreshForceCache,
            ),
          ),
        );

      //SEND REQUEST
      Response response = await ApiUtil.get(
        dio: dio,
        url: walletPageMainUrl,
      );
      return response;
    }
  }

  Future checkBillStatus() async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(
            policy: CachePolicy.refreshForceCache,
          ),
        ),
      );

    //SEND REQUEST
    Response response = await ApiUtil.get(
      dio: dio,
      url: walletPageMainUrl,
    );
    return response;
  }

  Future cancelBill() async {
    BaseOptions options = new BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 9000,
    );
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    ///ADD TIME OUT TO REQUEST
    dio = Dio(options)
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(
            policy: CachePolicy.refreshForceCache,
          ),
        ),
      );

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      useToken: true,
      url: AppApi.paymentBaseUrl + "/wallet/bill/cancel/",
    );
    return response;
  }

  Future createBill(
      double selectedAmount, bool shouldCancelPreviousBill) async {
    //GET CACHE OPTIONS
    CacheOptions cacheOptions = await AppApi.getDioWalletRequestsCacheOptions();

    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(
          options: cacheOptions.copyWith(
            policy: CachePolicy.refreshForceCache,
          ),
        ),
      );

    //SEND REQUEST
    Response response = await ApiUtil.post(
      dio: dio,
      useToken: true,
      url: AppApi.paymentBaseUrl + "/wallet/bill/create/",
      data: {
        'amount': selectedAmount,
        'cancel_existing': shouldCancelPreviousBill ? 1 : 0,
      },
    );
    return response;
  }

  Future getWalletHistory(int page, int pageSize) async {
    dio = Dio();

    Response response = await ApiUtil.get(
      dio: dio,
      url: AppApi.paymentBaseUrl + "/history/",
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return response;
  }

  List<WalletHistoryGroup> groupWalletHistory(
      List<WalletHistory> walletHistoryList) {
    var groupByDate = groupBy(
        walletHistoryList,
        (WalletHistory walletHistory) =>
            walletHistory.dateCreated.toIso8601String().substring(0, 10));

    List<WalletHistoryGroup> walletHistoryGroups = [];

    groupByDate.forEach((date, list) {
      // Header
      print('groupByDate DATEEE  ${date}:');

      WalletHistoryGroup walletHistoryGroup = WalletHistoryGroup(
        dateTime: DateTime.parse(date),
        walletHistoryList: list,
      );
      walletHistoryGroups.add(walletHistoryGroup);

      // Group
      list.forEach((listItem) {
        // List item
        print('groupByDate LIST ITEMM ${listItem.dateCreated}');
      });
      // day section divider
      print('\n');
    });
    return walletHistoryGroups;
  }

  cancel() {
    if (dio != null) {
      dio.close(force: true);
    }
  }
}
