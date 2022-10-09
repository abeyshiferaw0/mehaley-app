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
          // child: Image.asset(
          //   AppAssets.imageSignUpBg,
          //   fit: BoxFit.cover,
          // ),
          child: Image.network(
            "https://live.staticflickr.com/7146/26348041973_c56b99c48e_b.jpg",
            //"https://i.pinimg.com/564x/87/2f/c8/872fc8d91f8dd50157eb6b518bf62bec.jpg",
            //"https://i.pinimg.com/564x/6b/6d/d4/6b6dd4e51f8613f1adb43d40c1ed1bcf.jpg",
            //"https://i.pinimg.com/564x/36/7a/30/367a3009c9551c6a50233c0f3aea1b9c.jpg",
            //"https://i.pinimg.com/564x/0a/a2/e0/0aa2e0eb914d8264bca1deabe4dd49ee.jpg",
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
