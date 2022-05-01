import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/dialog/dialog_debug_custom_ip.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ///SHOW CUSTOM ID DIALOG FOR DEBUGGING PURPOSE
      if (AppValues.kisDebug) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: "DEBUG",
          builder: (context) {
            return DialogCustomIP(
              onIpSet: () {
                ///CHECK AUTH HERE
                checkIfUserLoggedIn();
              },
            );
          },
        );
      } else {
        ///CHECK AUTH HERE
        checkIfUserLoggedIn();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ColorMapper.getPagesBgColor(),
          appBar: AppBar(
            toolbarHeight: 0.0,
            leading: SizedBox(),
            systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
          ),
          body: SizedBox(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            // color: ColorMapper.getPagesBgColor(),
            child: Center(
              child: Image.asset(
                AppAssets.icSplashIcon,
                width: ScreenUtil(context: context).getScreenWidth() * 0.41,
                height: ScreenUtil(context: context).getScreenWidth() * 0.41,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void checkIfUserLoggedIn() async {
    bool isUserLoggedIn = await AuthUtil.isUserLoggedIn();
    if (isUserLoggedIn) {
      Navigator.popAndPushNamed(context, AppRouterPaths.mainScreen);
    } else {
      Navigator.popAndPushNamed(context, AppRouterPaths.signUp);
    }
  }
}
