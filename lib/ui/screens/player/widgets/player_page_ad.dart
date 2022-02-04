import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/app_ad_bloc/app_ad_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_ad.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/app_ad_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayerPageAd extends StatefulWidget {
  const PlayerPageAd({Key? key}) : super(key: key);

  @override
  _PlayerPageAdState createState() => _PlayerPageAdState();
}

class _PlayerPageAdState extends State<PlayerPageAd> {
  late WebViewController webViewController;

  ///
  double opacity = 0.0;
  bool shouldShowAd = false;

  ///
  late Timer _timer;
  double progress = 0;
  final oneSec = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    if (!AppAdUtil.isPlayerAdShownRecently()) {
      shouldShowAd = true;
    }

    _timer = Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        timer.cancel();
      },
    );

    AppAdUtil.remove();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAdBloc, AppAdState>(
      builder: (context, state) {
        if (state is AppAdLoadedState) {
          AppAd? appAd = AppAdUtil.getAppAdForPlayerPage(
            state.appAdData.appAdList,
          );

          if (appAd != null) {
            ///SHOW ADD IF AD NOT SHOWN RECENTLY
            if (shouldShowAd) {
              return buildAdWebView(appAd);
            }
          }
        }
        return SizedBox();
      },
    );
  }

  Widget buildAdWebView(AppAd appAd) {
    return Container(
      child: AnimatedOpacity(
        opacity: opacity,
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: [
            Stack(
              children: [
                ///REMOVE TOUCH LISTENER FROM AD WEB VIEW
                AbsorbPointer(
                  child: WebView(
                    initialUrl: appAd.link.toString(),
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      webViewController = webViewController;
                    },
                    navigationDelegate: (NavigationRequest request) {
                      return NavigationDecision.prevent;
                    },
                    onPageStarted: (String url) {
                      print("ADDDD=> onPageStarted");
                      setState(() {
                        opacity = 0.0;
                      });
                    },
                    onPageFinished: (String url) {
                      print("ADDDD=> onPageFinished");
                      setState(() {
                        opacity = 1.0;
                      });
                      _timer = Timer.periodic(
                        oneSec,
                        (Timer timer) {
                          if (progress < 1.0) {
                            ///INCREMENT PROGRESS INDICATOR
                            setState(() {
                              progress = progress + (1 / appAd.maxAdLength);
                            });

                            if (progress > 0.4) {
                              ///IF AD SHOW MORE THAN A QUARTER
                              ///SET RECENTLY AD SHOWN
                              AppAdUtil.adRecentlyShown();
                            }
                          } else {
                            timer.cancel();
                          }
                        },
                      );
                    },
                    onWebResourceError: (WebResourceError error) {
                      if (webViewController != null) {
                        webViewController.reload();
                      }
                      print("ADDDD=> onWebResourceError");
                      setState(() {
                        opacity = 0.0;
                      });
                    },
                    zoomEnabled: false,
                    gestureNavigationEnabled: false,
                    backgroundColor: AppColors.pagesBgColor,
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
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.completelyBlack.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: EdgeInsets.all(AppPadding.padding_6),
                    margin: EdgeInsets.all(AppMargin.margin_8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: progress < 0.9,
                          child: Container(
                            width: AppIconSizes.icon_size_32,
                            height: AppIconSizes.icon_size_32,
                            padding: EdgeInsets.all(AppPadding.padding_6),
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              value: progress,
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: progress > 0.9,
                          child: AppBouncingButton(
                            onTap: () {
                              setState(() {
                                progress = 0.0;
                                opacity = 0.0;
                              });
                            },
                            child: Icon(
                              FlutterRemix.close_line,
                              color: AppColors.white,
                              size: AppIconSizes.icon_size_32,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
