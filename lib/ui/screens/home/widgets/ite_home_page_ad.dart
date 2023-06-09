import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/app_ad_bloc/app_ad_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_ad.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/util/app_ad_util.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ItemHomePageAd extends StatefulWidget {
  const ItemHomePageAd({Key? key, required this.appAddEmbedPlace})
      : super(key: key);

  final AppAddEmbedPlace appAddEmbedPlace;

  @override
  _ItemHomePageAdState createState() => _ItemHomePageAdState();
}

class _ItemHomePageAdState extends State<ItemHomePageAd> {
  late WebViewController webViewController;

  ///
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAdBloc, AppAdState>(
      builder: (context, state) {
        if (state is AppAdLoadedState) {
          AppAd? appAd = AppAdUtil.getAppAdForHomePage(
            state.appAdData.appAdList,
            widget.appAddEmbedPlace,
          );

          if (appAd != null) {
            return buildAdWebView(appAd);
          }
        }
        return SizedBox();
      },
    );
  }

  Widget buildAdWebView(AppAd appAd) {
    return Container(
      margin: EdgeInsets.only(
        bottom: widget.appAddEmbedPlace == AppAddEmbedPlace.HOME_PAGE_MIDDLE
            ? AppMargin.margin_32
            : 0,
        top: AppMargin.margin_32,
      ),
      height: appAd.preferredHeight.sp,
      child: Stack(
        children: [
          ///REMOVE TOUCH LISTENER FROM AD WEB VIEW
          AbsorbPointer(
            child: WebView(
              initialUrl: appAd.link.toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                print('WebView=> onWebViewCreated=>');
                webViewController = webViewController;
              },
              // navigationDelegate: (NavigationRequest request) {
              //   print('WebView=> navigationDelegate=> ${request.url}');
              //   return NavigationDecision.navigate;
              // },
              onPageStarted: (String url) {
                print('WebView=> onPageStarted=> ${url}');
                setState(() {
                  loading = true;
                });
              },
              onPageFinished: (String url) {
                print('WebView=> onPageFinished=> ${url}');
                setState(() {
                  loading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                print('WebView=> onWebResourceError=> ${error.description}');
                webViewController.reload();
                setState(() {
                  loading = true;
                });
              },
              zoomEnabled: false,
              gestureNavigationEnabled: false,
              backgroundColor: ColorMapper.getPagesBgColor(),
            ),
          ),
          GestureDetector(
            child: SizedBox.expand(
              child: Container(
                color: AppColors.transparent,
              ),
            ),
            onTap: () {
              ///APP AD CLICK ACTION
              if (appAd.appAdAction != null) {
                if (appAd.appAdAction == AppAdAction.LAUNCH_URL) {
                  if (appAd.actionLaunchLink != null) {
                    AppAdUtil.launchInBrowser(
                      appAd.actionLaunchLink.toString(),
                    );
                  }
                }
                if (appAd.appAdAction == AppAdAction.CALL) {
                  if (appAd.actionPhoneNumber != null) {
                    AppAdUtil.call(appAd.actionPhoneNumber.toString());
                  }
                }
              }
            },
          ),
          Visibility(
            visible: loading,
            child: SizedBox.expand(
              child: Container(
                color: ColorMapper.getPagesBgColor(),
                child: AppLoading(
                  size: AppValues.loadingWidgetSize * 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
