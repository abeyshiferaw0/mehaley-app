import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/iap_purchase_action_bloc/iap_purchase_action_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:mehaley/util/yenepay_purchase_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_loading.dart';

class DialogYenepayCheckoutWebView extends StatefulWidget {
  const DialogYenepayCheckoutWebView({
    Key? key,
    required this.itemId,
    required this.item,
    required this.appPurchasedItemType,
    required this.checkOutUrl,
    required this.appPurchasedSources,
    required this.isFromSelfPage,
  }) : super(key: key);

  final int itemId;
  final dynamic item;
  final AppPurchasedItemType appPurchasedItemType;
  final String checkOutUrl;
  final AppPurchasedSources appPurchasedSources;
  final bool isFromSelfPage;

  @override
  State<DialogYenepayCheckoutWebView> createState() =>
      _DialogYenepayCheckoutWebViewState();
}

class _DialogYenepayCheckoutWebViewState
    extends State<DialogYenepayCheckoutWebView> {
  ///
  bool hasError = false;
  bool loading = true;
  late WebViewController webViewContainer;

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
              width: ScreenUtil(context: context).getScreenWidth() * 0.9,
              height: ScreenUtil(context: context).getScreenHeight() * 0.7,
              color: AppColors.white,
              child: Column(
                children: [
                  AppTopHeaderWithIcon(),
                  Expanded(
                    child: Stack(
                      children: [
                        buildWebView(),
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

  WebView buildWebView() {
    return WebView(
      initialUrl: widget.checkOutUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (mWebViewController) {
        webViewContainer = mWebViewController;
      },
      onPageStarted: (String s) {
        setState(() {
          loading = true;
          hasError = false;
        });

        ///IF RETURN URL SUCCESS , CANCEL , FAILURE HANDLE ACCORDINGLY
        dialogReturnActions(s);
      },
      onPageFinished: (String s) {
        if (checkIfIsReturnUrl(s)) {
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
        if (checkIfIsReturnUrl(error.failingUrl)) {
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
                webViewContainer.reload();
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
    // ///SAVE TO RECENTLY PURCHASED
    // BlocProvider.of<RecentlyPurchasedItemsBloc>(context).add(
    //   SaveRecentlyPurchasedItemEvent(
    //     item: widget.item,
    //     appPurchasedItemType: widget.appPurchasedItemType,
    //   ),
    // );

    ///YENEPAY PURCHASE SUCCESS ACTIONS MAPPING
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
    Navigator.pop(context);
  }

  void onCancel() {
    ScaffoldMessenger.of(context).showSnackBar(
      buildAppSnackBar(
        bgColor: AppColors.blue,
        isFloating: true,
        msg: "Payment was canceled!!",
        txtColor: AppColors.white,
      ),
    );
    Navigator.pop(context);
  }

  void onFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      buildAppSnackBar(
        bgColor: AppColors.errorRed,
        isFloating: false,
        msg: "Something went wrong",
        txtColor: AppColors.white,
      ),
    );
    Navigator.pop(context);
  }

  dialogReturnActions(returnUrl) {
    bool isSuccessReturnUrl = YenepayPurchaseUtil.isSuccessReturnUrl(returnUrl);
    bool isCancelReturnUrl = YenepayPurchaseUtil.isCancelReturnUrl(returnUrl);
    bool isFailureReturnUrl = YenepayPurchaseUtil.isFailureReturnUrl(returnUrl);

    if (isSuccessReturnUrl) {
      onSuccess();
    }
    if (isCancelReturnUrl) {
      onCancel();
    }
    if (isFailureReturnUrl) {
      onFailure();
    }
  }

  bool checkIfIsReturnUrl(String? failingUrl) {
    if (failingUrl == null) return false;
    bool isSuccessReturnUrl =
        YenepayPurchaseUtil.isSuccessReturnUrl(failingUrl);
    bool isCancelReturnUrl = YenepayPurchaseUtil.isCancelReturnUrl(failingUrl);
    bool isFailureReturnUrl =
        YenepayPurchaseUtil.isFailureReturnUrl(failingUrl);
    if (isSuccessReturnUrl || isCancelReturnUrl || isFailureReturnUrl) {
      return true;
    }
    return false;
  }
}
