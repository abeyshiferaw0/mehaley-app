import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_purchase_action_bloc/iap_purchase_action_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/payment_utils/telebirr_purchase_util.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_loading.dart';

class DialogTelebirrCheckoutWebView extends StatefulWidget {
  const DialogTelebirrCheckoutWebView({
    Key? key,
    required this.itemId,
    required this.appPurchasedItemType,
    required this.checkOutUrl,
    required this.transactionNumber,
    required this.resultSuccessRedirectUrl,
    required this.appPurchasedSources,
    required this.isFromSelfPage,
  }) : super(key: key);

  final int itemId;

  final AppPurchasedItemType appPurchasedItemType;
  final String checkOutUrl;
  final String transactionNumber;
  final String resultSuccessRedirectUrl;

  final AppPurchasedSources appPurchasedSources;
  final bool isFromSelfPage;

  @override
  State<DialogTelebirrCheckoutWebView> createState() =>
      _DialogTelebirrCheckoutWebViewState();
}

class _DialogTelebirrCheckoutWebViewState
    extends State<DialogTelebirrCheckoutWebView> {
  ///
  bool hasError = false;
  bool loading = true;
  late WebViewController webViewController;

  @override
  void initState() {
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
              color: AppColors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        buildWebView(),
                        buildLoading(),
                        buildError(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: AppTopHeaderWithIcon(),
                        ),
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

  WebView buildWebView() {
    return WebView(
      initialUrl: widget.checkOutUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (mWebViewController) {
        webViewController = mWebViewController;
      },
      onPageStarted: (String s) {
        setState(() {
          loading = true;
          hasError = false;
        });
      },
      onPageFinished: (String s) {
        if (TelebirrPurchaseUtil.isReturnUrl(s)) {
          setState(() {
            loading = true;
            hasError = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }

        ///IF RETURN URL RESULT SUCCESS , CANCEL , FAILURE HANDLE ACCORDINGLY
        dialogReturnActions(s);
      },
      onProgress: (int s) {},
      onWebResourceError: (WebResourceError error) {
        loading = false;
        hasError = true;
      },
    );
  }

  Widget buildLoading() {
    return Visibility(
      visible: loading,
      child: Container(
        color: AppColors.white,
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
        color: AppColors.white,
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

    ///TELEBIRR PURCHASE SUCCESS ACTIONS MAPPING
    if (widget.appPurchasedItemType == AppPurchasedItemType.SONG_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapSongPurchaseActionEvent(
          itemId: widget.itemId,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
    if (widget.appPurchasedItemType == AppPurchasedItemType.ALBUM_PAYMENT) {
      BlocProvider.of<IapPurchaseActionBloc>(context).add(
        IapAlbumPurchaseActionEvent(
          itemId: widget.itemId,
          isFromSelfPage: widget.isFromSelfPage,
          appPurchasedSources: widget.appPurchasedSources,
        ),
      );
    }
    if (widget.appPurchasedItemType == AppPurchasedItemType.PLAYLIST_PAYMENT) {
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
        txtColor: AppColors.white,
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
        txtColor: AppColors.white,
      ),
    );
  }

  dialogReturnActions(returnUrl) {
    ///CHECK REDIRECTED URL
    bool isCompletedReturnUrl =
        TelebirrPurchaseUtil.isCompletedReturnUrl(returnUrl);
    bool isAlreadyPaidReturnUrl =
        TelebirrPurchaseUtil.isAlreadyPaidReturnUrl(returnUrl);
    bool isFreeReturnUrl = TelebirrPurchaseUtil.isFreeReturnUrl(returnUrl);
    bool isFailureReturnUrl =
        TelebirrPurchaseUtil.isFailureReturnUrl(returnUrl);

    ///CHECK IF IS TELEBIRR RESULT PAGE
    bool isResultFailureUrl =
        TelebirrPurchaseUtil.isResultFailureUrl(returnUrl);
    bool isResultSuccessUrl =
        TelebirrPurchaseUtil.isResultSuccessUrl(returnUrl);

    if (isResultFailureUrl) {
      onFailure();
    }
    if (isCompletedReturnUrl || isAlreadyPaidReturnUrl || isFreeReturnUrl) {
      onSuccess();
    }
    if (isFailureReturnUrl) {
      onFailure();
    }
    if (isResultSuccessUrl) {
      String status = TelebirrPurchaseUtil.getResultSuccessUrlStatus(returnUrl);
      webViewController.loadUrl(
        '${widget.resultSuccessRedirectUrl}?transactionNo=${widget.transactionNumber}&status=$status',
      );
    }
  }
}
