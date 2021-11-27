import 'package:flutter/material.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ///CHECK AUTH HERE
      checkIfUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pagesBgColor,
      appBar: AppBar(
        toolbarHeight: 0.0,
        leading: SizedBox(),
        systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
        backgroundColor: AppColors.transparent,
        shadowColor: AppColors.transparent,
      ),
      body: Container(
        color: AppColors.pagesBgColor,
        child: Center(
          child: Image.asset(
            AppAssets.icAppFullIcon,
          ),
        ),
      ),
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
