import 'package:dio/dio.dart';
import 'package:mehaley/data/data_providers/wallet_data_provider.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/data/models/payment/wallet_history.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';

class WalletDataRepository {
  //INIT PROVIDER FOR API CALL
  final WalletDataProvider walletDataProvider;

  const WalletDataRepository({required this.walletDataProvider});

  Future<WalletPageData> getWalletData(
      AppCacheStrategy appCacheStrategy) async {
    Response response =
        await walletDataProvider.getWalletData(appCacheStrategy);

    WalletPageData walletPageData = parseWalletPageData(response);

    return walletPageData;
  }

  Future<WalletPageData> checkBillStatus() async {
    Response response = await walletDataProvider.checkBillStatus();

    WalletPageData walletPageData = parseWalletPageData(response);

    return walletPageData;
  }

  Future<WalletPageData> cancelBill() async {
    Response response = await walletDataProvider.cancelBill();

    WalletPageData walletPageData = parseWalletPageData(response);

    return walletPageData;
  }

  Future<List<WalletHistory>> getWalletHistory(int page, int pageSize) async {
    final List<WalletHistory> walletHistoryList;

    Response response =
        await walletDataProvider.getWalletHistory(page, pageSize);

    //PARSE LIST OF WALLET HISTORIES
    walletHistoryList = (response.data as List)
        .map((walletHistory) => WalletHistory.fromMap(walletHistory))
        .toList();

    return walletHistoryList;
  }

  Future<WalletPageData> createBill(
      double selectedAmount, bool shouldCancelPreviousBill) async {
    Response response = await walletDataProvider.createBill(
        selectedAmount, shouldCancelPreviousBill);

    WalletPageData walletPageData = parseWalletPageData(response);

    return walletPageData;
  }

  WalletPageData parseWalletPageData(response) {
    final WebirrBill? freshBill;
    final WebirrBill? activeBill;
    final double walletBalance;
    final DateTime today;
    final List<PaymentMethod> paymentMethods;

    //PARSE FRESH BILL
    freshBill = response.data['fresh_bill'] != null
        ? WebirrBill.fromMap(response.data['fresh_bill'])
        : null;

    //PARSE ACTIVE BILL
    activeBill = response.data['active_bill'] != null
        ? WebirrBill.fromMap(response.data['active_bill'])
        : null;

    //PARSE SERVER TODAY DATE
    today = DateTime.parse(response.data['today']);

    //PARSE WALLET BALANCE
    walletBalance = response.data['balance'];

    //PARSE PAYMENT METHODS
    paymentMethods = (response.data['payment_methods'] as List)
        .map((paymentMethod) => PaymentMethod.fromMap(paymentMethod))
        .toList();

    WalletPageData walletPageData = WalletPageData(
      freshBill: freshBill,
      activeBill: activeBill,
      walletBalance: walletBalance,
      today: today,
      paymentMethods: paymentMethods,
      response: response,
    );

    return walletPageData;
  }

  cancelDio() {
    walletDataProvider.cancel();
  }
}
