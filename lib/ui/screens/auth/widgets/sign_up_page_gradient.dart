import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/screen_util.dart';

class SignUpPageBg extends StatelessWidget {
  const SignUpPageBg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: ScreenUtil(context: context).getScreenWidth(),
          height: ScreenUtil(context: context).getScreenHeight(),
          child: Image.asset(
            AppAssets.imageSignUpBg,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: ScreenUtil(context: context).getScreenWidth(),
          height: ScreenUtil(context: context).getScreenHeight(),
          decoration: BoxDecoration(
            gradient: AppGradients().getSignInPageGradient(),
          ),
        )
      ],
    );
  }
}
