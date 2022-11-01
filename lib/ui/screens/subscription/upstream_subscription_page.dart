import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/payment/ethio_tele_subscription_offerings.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/widget_error_widget.dart';
import 'package:mehaley/util/api_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/ethio_telecom_subscription_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UpstreamSubscriptionPage extends StatefulWidget {
  const UpstreamSubscriptionPage(
      {Key? key, required this.ethioTeleSubscriptionOfferings})
      : super(key: key);

  final EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings;

  @override
  State<UpstreamSubscriptionPage> createState() =>
      _UpstreamSubscriptionPageState();
}

class _UpstreamSubscriptionPageState extends State<UpstreamSubscriptionPage> {
  ///
  bool hasError = false;
  bool loading = true;
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorMapper.getWhite(),
      child: SafeArea(
        child: Column(
          children: [
            AppTopHeaderWithIcon(
              enableCloseWarning: false,
            ),
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

  buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC
          ? AppUpStreamLinks.subscriptionInitialLinkAm
          : AppUpStreamLinks.subscriptionInitialLinkEn,
      navigationDelegate: (NavigationRequest request) {
        ///IF RETURN URL SUCCESS , CANCEL , FAILURE HANDLE ACCORDINGLY
        dialogReturnActions(request.url);

        print('ETHIO SUB TEST =>>   NavigationRequest => ${request.url} ');

        return NavigationDecision.navigate;
      },
      onWebViewCreated: (mWebViewController) {
        webViewController = mWebViewController;
      },
      onPageStarted: (String s) {
        print('ETHIO SUB TEST =>>   onPageStarted => ${s} ');
        setState(() {
          loading = true;
          hasError = false;
        });
      },
      onPageFinished: (String s) {
        setState(() {
          loading = false;
          hasError = false;
        });
      },
      onProgress: (int s) {
        print('ETHIO SUB TEST =>>   onProgress => ${s} ');
      },
      onWebResourceError: (WebResourceError error) {
        setState(() {
          loading = false;
          hasError = true;
        });
        print(
            'ETHIO SUB TEST =>>   onWebResourceError => ${error.failingUrl} ');
      },
    );
  }

  dialogReturnActions(String returnUrl) {
    ///CHECK REDIRECTED URL
    bool isRedirectToSms =
        EthioTelecomSubscriptionUtil.isUrlRedirectToSms(returnUrl);
    bool isSubscriptionSuccess =
        EthioTelecomSubscriptionUtil.isUrlSubscriptionSuccess(returnUrl);

    print('ETHIO SUB TEST => ${isRedirectToSms} ${isSubscriptionSuccess}   ');

    if (isRedirectToSms) {
      onRedirectToSms();
    }
    if (isSubscriptionSuccess) {
      onSubscriptionSuccess();
    }
  }

  void onRedirectToSms() {
    Navigator.pop(context);

    PagesUtilFunctions.ethioTelecomSubscribeClicked(
        widget.ethioTeleSubscriptionOfferings);
  }

  void onSubscriptionSuccess() async {
    ///CLEAR ALL CACHE
    await ApiUtil.deleteAllCache();
    await ApiUtil.setRecentlyPurchased(true);

    ///STOP PLAYER
    BlocProvider.of<AudioPlayerBloc>(context).add(
      StopPlayerEvent(),
    );

    setState(() {
      loading = true;
      hasError = false;
    });

    await Future.delayed(
      Duration(seconds: 3),
    );

    ///
    Navigator.pop(context);

    ///
    Navigator.pushNamed(
      context,
      AppRouterPaths.homeRoute,
    );
  }
}
