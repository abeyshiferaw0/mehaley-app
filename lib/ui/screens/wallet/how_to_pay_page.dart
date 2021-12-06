import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_error_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HowToPayPage extends StatefulWidget {
  const HowToPayPage({Key? key, required this.initialUrl}) : super(key: key);

  final String initialUrl;

  @override
  State<HowToPayPage> createState() => _HowToPayPageState();
}

class _HowToPayPageState extends State<HowToPayPage> {
  ///
  bool loading = true;
  bool hasError = false;
  late WebViewController webViewContainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.pagesBgColor,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (mWebViewController) {
              webViewContainer = mWebViewController;
            },
            onPageStarted: (String s) {
              setState(() {
                loading = true;
                hasError = false;
              });
            },
            onPageFinished: (String s) {
              setState(() {
                loading = false;
              });
            },
            onProgress: (int s) {},
            onWebResourceError: (error) {
              setState(() {
                loading = false;
                hasError = true;
              });
            },
          ),
          Visibility(
            visible: loading,
            child: Container(
              color: AppColors.white,
              child: Center(
                child: AppLoading(
                  size: AppValues.loadingWidgetSize * 0.8,
                ),
              ),
            ),
          ),
          Visibility(
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
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      backgroundColor: AppColors.pagesBgColor,
      shadowColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          FlutterRemix.arrow_left_line,
          size: AppIconSizes.icon_size_24,
          color: AppColors.black,
        ),
      ),
      title: Text(
        AppLocale.of().howToPay,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
}
