import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestTwoWidget extends StatefulWidget {
  const TestTwoWidget({Key? key}) : super(key: key);

  @override
  _TestTwoWidgetState createState() => _TestTwoWidgetState();
}

class _TestTwoWidgetState extends State<TestTwoWidget> {
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
    return Scaffold(
      body: WebView(
        initialUrl:
            '${AppApi.baseUrl}/payment/purchase/yene_pay/web_payment/?item_id=462&item_type=SONG_PAYMENT&user_id=4',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (mWebViewController) {
          webViewContainer = mWebViewController;
        },
        onPageStarted: (String s) {
          //print("WebViewww=> onPageStarted ${s}");
        },
        onPageFinished: (String s) {
          //print("WebViewww=> onPageFinished ${s}");
        },
        onProgress: (int s) {
          ////print("WebViewww=> onProgress ${s}");
        },
        onWebResourceError: (WebResourceError error) {
          //print("WebViewww=> onWebResourceError ${error.failingUrl}");
        },
      ),
    );
  }
}
