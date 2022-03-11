import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/ui/screens/auth/widgets/app_info_carousel.dart';
import 'package:mehaley/ui/screens/auth/widgets/sign_up_page_button.dart';
import 'package:mehaley/ui/screens/auth/widgets/sign_up_page_circle_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

class SignUpPageFront extends StatelessWidget {
  const SignUpPageFront({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///HEAR LOGO
        buildAppLogo(),
        SizedBox(height: AppMargin.margin_16),

        ///APP INFO CAROUSEL
        AppInfoCarousel(),

        SizedBox(height: AppMargin.margin_32),

        ///SIGN UP TEXTS
        buildSignUpButtons(context),
        SizedBox(height: AppMargin.margin_48),

        ///APP NAME AND VERSION
        buildAppVersion(),
        SizedBox(height: AppMargin.margin_16),
      ],
    );
  }

  FutureBuilder buildAppVersion() {
    return FutureBuilder(
      future: PagesUtilFunctions.getAppVersionNumber(),
      initialData: 'loading',
      builder: (context, snapShot) {
        if (snapShot.data != null) {
          if (snapShot.data is String) {
            return Text(
              AppLocale.of().appNameAndVersion(
                versionCode: snapShot.data,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: ColorMapper.getTxtGrey(),
              ),
            );
          }
        }
        return SizedBox();
      },
    );
  }

  Container buildSignUpButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SignUpButton(
            title: AppLocale.of().continueWithPhone,
            icon: AppAssets.icPhone,
            userLoginType: UserLoginType.PHONE_NUMBER,
            color: ColorMapper.getDarkOrange(),
            isFilled: true,
            noBorder: false,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouterPaths.verifyPhonePageOne,
              );
            },
          ),
          SizedBox(height: AppMargin.margin_32),

          ///SOCIAL LOGIN BUTTONS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignUpCircleButton(
                title: AppLocale.of().google,
                icon: AppAssets.icGoogle,
                userLoginType: UserLoginType.GOOGLE,
                onTap: () {
                  //LOGIN WITH GOOGLE
                  BlocProvider.of<AuthBloc>(context).add(
                    ContinueWithGoogleEvent(),
                  );
                },
              ),
              SizedBox(width: AppMargin.margin_24),
              SignUpCircleButton(
                title: AppLocale.of().facebook,
                icon: AppAssets.icFacebook,
                userLoginType: UserLoginType.FACEBOOK,
                onTap: () {
                  //LOGIN WITH FACEBOOK
                  BlocProvider.of<AuthBloc>(context).add(
                    ContinueWithFacebookEvent(),
                  );
                },
              ),
              Platform.isIOS
                  ? FutureBuilder<bool>(
                      future: SignInWithApple.isAvailable(),
                      builder: (context, snapShot) {
                        if (snapShot.data == null) return SizedBox();
                        if (snapShot.data == false) return SizedBox();
                        return Row(
                          children: [
                            SizedBox(width: AppMargin.margin_24),
                            SignUpCircleButton(
                              title: AppLocale.of().apple,
                              icon: AppAssets.icApple,
                              userLoginType: UserLoginType.APPLE,
                              onTap: () {
                                //LOGIN WITH APPLE
                                BlocProvider.of<AuthBloc>(context).add(
                                  ContinueWithAppleEvent(),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Image buildAppLogo() {
    return Image.asset(
      AppAssets.icAppWordIcon,
      width: AppValues.signUpAppIconSize,
      fit: BoxFit.contain,
    );
  }
}
