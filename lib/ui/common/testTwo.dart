import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/yenepay/yenepay_payment_launcher_listener_bloc/yenepay_payment_launcher_listener_bloc.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class TestTwoWidget extends StatefulWidget {
  const TestTwoWidget({Key? key}) : super(key: key);

  @override
  _TestTwoWidgetState createState() => _TestTwoWidgetState();
}

class _TestTwoWidgetState extends State<TestTwoWidget> {
  @override
  void initState() {
    linkStream.listen((String? link) {
      print("linkStream  link=>  ${link}");
      closeWebView();
    }, onError: (err) {
      print("linkStream  err=>  ${err}");
    });
    BlocProvider.of<YenepayPaymentLauncherListenerBloc>(context).add(
      StartYenepayPaymentListenerEvent(),
    );
    super.initState();
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: IconButton(
      //     icon: Icon(FlutterRemix.play_circle_line),
      //     onPressed: () {
      //       canL(
      //           "https://app.ethiomobilemoney.et:2121/ammsdkpay/#/?transactionNo=202201271332311486648307689631746");
      //     },
      //   ),
      // ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                'https://app.ethiomobilemoney.et:2121/ammsdkpay/#/result')),
        initialOptions: options,
        onWebViewCreated: (controller) {
          webViewController = controller;
          controller.addJavaScriptHandler(
              handlerName: 'paymentResult',
              callback: (args) {
                print("WEBVIEW_TEST=> callback $args");
                // print arguments coming from the JavaScript side!
                print(args);
              });
        },
        onLoadStart: (controller, url) {
          print("WEBVIEW_TEST=> onLoadStart");
        },
        onLoadStop: (controller, url) async {
          print("WEBVIEW_TEST=> onLoadStop");
        },
        onLoadError: (controller, url, code, message) {
          print("WEBVIEW_TEST=> onLoadError");
        },
      ),
    );
  }

  canL(String urlString) async {
    bool can = true;
    print("TEST_URL=>  can $can");
    if (can) {
      try {
        print("TEST_URL=>  launch $urlString");
        launch(urlString);
      } catch (e) {
        print("TEST_URL=>  catch ${e.toString()}");
      }
    }
  }
}
