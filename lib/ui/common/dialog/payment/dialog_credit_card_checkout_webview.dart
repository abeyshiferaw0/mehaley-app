import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_action_bloc/iap_purchase_action_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/credit_card_check_out_api_result_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/payment_utils/credit_card_purchase_util.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_loading.dart';

class DialogCreditCardCheckoutWebView extends StatefulWidget {
  const DialogCreditCardCheckoutWebView({
    Key? key,
    required this.itemId,
    required this.purchasedItemType,
    required this.checkOutUrl,
    required this.creditCardResult,
    required this.appPurchasedSources,
    required this.isFromSelfPage,
  }) : super(key: key);

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final String checkOutUrl;
  final CreditCardResult creditCardResult;
  final AppPurchasedSources appPurchasedSources;
  final bool isFromSelfPage;

  @override
  State<DialogCreditCardCheckoutWebView> createState() =>
      _DialogCreditCardCheckoutWebViewState();
}

class _DialogCreditCardCheckoutWebViewState
    extends State<DialogCreditCardCheckoutWebView> {
  ///
  bool hasError = false;
  bool loading = true;
  late WebViewController webViewController;

  @override
  void initState() {
    ///FOR KEYBOARD NOT COVERING INPUT FIX
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        radius: 6,
        child: Wrap(
          children: [
            Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.95,
              height: ScreenUtil(context: context).getScreenHeight() * 0.9,
              color: ColorMapper.getWhite(),
              child: Column(
                children: [
                  AppTopHeaderWithIcon(
                    enableCloseWarning: true,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        buildWebView(
                          widget.checkOutUrl,
                          widget.creditCardResult,
                        ),
                        buildLoading(),
                        buildError(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold buildWebView(String checkOutUrl, CreditCardResult creditCardResult) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: CreditCardPurchaseUtil.getCyberSourceFormDataUrl(
          checkOutUrl,
          creditCardResult,
        ),
        navigationDelegate: (NavigationRequest request) {
          print('CREDIT_CARDRR=>>   NavigationRequest => ${request.url} ');
          return NavigationDecision.navigate;
        },
        onWebViewCreated: (mWebViewController) {
          webViewController = mWebViewController;
        },
        onPageStarted: (String s) {
          print('CREDIT_CARDRR=>>   onPageStarted => ${s} ');
          setState(() {
            loading = true;
            hasError = false;
          });

          ///IF RETURN URL SUCCESS , CANCEL , FAILURE HANDLE ACCORDINGLY
          dialogReturnActions(s);
        },
        onPageFinished: (String s) {
          if (CreditCardPurchaseUtil.isReturnUrl(s)) {
            setState(() {
              loading = true;
              hasError = false;
            });
          } else {
            setState(() {
              loading = false;
            });
          }
        },
        onProgress: (int s) {},
        onWebResourceError: (WebResourceError error) {
          if (CreditCardPurchaseUtil.isReturnUrl(error.failingUrl)) {
            setState(() {
              loading = true;
              hasError = false;
            });
          } else {
            setState(() {
              loading = false;
              hasError = true;
            });
          }
          print(
              'CREDIT_CARDRR=>>   onWebResourceError => ${error.failingUrl} ');
        },
      ),
    );
  }

  Widget buildLoading() {
    return Visibility(
      visible: loading,
      child: Container(
        color: ColorMapper.getWhite(),
        child: Center(
          child: AppLoading(
            size: AppValues.loadingWidgetSize * 0.8,
          ),
        ),
      ),
    );
  }

  Widget buildError() {
    return Visibility(
      visible: hasError,
      child: Container(
        color: ColorMapper.getWhite(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_32,
            ),
            child: WidgetErrorWidget(
              onRetry: () {
                webViewController.reload();
              },
              title: AppLocale.of().noInternetMsgDetail,
              subTitle: '',
            ),
          ),
        ),
      ),
    );
  }

  void onSuccess() {
    Navigator.pop(context);

    ///CREDIT_CARD PURCHASE SUCCESS ACTIONS MAPPING
    if (widget.purchasedItemType == PurchasedItemType.SONG_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapSongPurchaseActionEvent(
          itemId: widget.itemId,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
    if (widget.purchasedItemType == PurchasedItemType.ALBUM_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapAlbumPurchaseActionEvent(
          itemId: widget.itemId,
          isFromSelfPage: widget.isFromSelfPage,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
    if (widget.purchasedItemType == PurchasedItemType.PLAYLIST_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapPlaylistPurchaseActionEvent(
          itemId: widget.itemId,
          isFromSelfPage: widget.isFromSelfPage,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
  }

  void onCancel() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      buildAppSnackBar(
        bgColor: AppColors.blue,
        isFloating: true,
        msg: AppLocale.of().paymentCanceled,
        txtColor: ColorMapper.getWhite(),
      ),
    );
  }

  void onFailure() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      buildAppSnackBar(
        bgColor: AppColors.errorRed,
        isFloating: false,
        msg: AppLocale.of().somethingWentWrong,
        txtColor: ColorMapper.getWhite(),
      ),
    );
  }

  dialogReturnActions(String returnUrl) {
    ///CHECK REDIRECTED URL
    bool isCompletedReturnUrl =
        CreditCardPurchaseUtil.isCompletedReturnUrl(returnUrl);
    bool isAlreadyPaidReturnUrl =
        CreditCardPurchaseUtil.isAlreadyPaidReturnUrl(returnUrl);
    bool isFreeReturnUrl = CreditCardPurchaseUtil.isFreeReturnUrl(returnUrl);
    bool isFailureReturnUrl =
        CreditCardPurchaseUtil.isFailureReturnUrl(returnUrl);

    print(
        'TESTTT => ${isCompletedReturnUrl} ${isAlreadyPaidReturnUrl}  ${isFreeReturnUrl}  ${isFailureReturnUrl} ');

    if (isCompletedReturnUrl || isAlreadyPaidReturnUrl || isFreeReturnUrl) {
      onSuccess();
    }
    if (isFailureReturnUrl) {
      onFailure();
    }
  }
}
