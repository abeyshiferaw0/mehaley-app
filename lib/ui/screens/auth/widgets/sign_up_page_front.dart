import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/screens/auth/widgets/app_info_carousel.dart';
import 'package:mehaley/ui/screens/auth/widgets/sign_up_page_button.dart';
import 'package:mehaley/ui/screens/auth/widgets/sign_up_page_circle_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

class SignUpPageFront extends StatefulWidget {
  const SignUpPageFront({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPageFront> createState() => _SignUpPageFrontState();
}

class _SignUpPageFrontState extends State<SignUpPageFront> {
  ///
  bool isOtherAuthVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: AppMargin.margin_16 * 3,
          // ),
          // buildAppLogo(),
          //
          // Expanded(child: SizedBox()),

          ///HEAR LOGO
          buildAppLetterLogo(),
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
      ),
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
            icon: Platform.isAndroid ? AppAssets.icPhone : null,
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

          Platform.isAndroid
              ? SizedBox(height: AppMargin.margin_32)
              : SizedBox(height: AppMargin.margin_8),

          Platform.isAndroid
              ? Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: AppPadding.padding_32,
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.white,
                            thickness: 0.2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppMargin.margin_8,
                          ),
                          child: Text(
                            "OR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_12.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorMapper.getTxtGrey(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(
                          width: AppPadding.padding_32,
                        ),
                      ],
                    ),
                    isOtherAuthVisible
                        ? SizedBox()
                        : Column(
                            children: [
                              SizedBox(height: AppMargin.margin_32),
                              AppBouncingButton(
                                onTap: () {
                                  setState(() {
                                    isOtherAuthVisible = !isOtherAuthVisible;
                                  });
                                },
                                child: Wrap(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppPadding.padding_2,
                                        vertical: AppPadding.padding_12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "See Other Options".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize:
                                                  AppFontSizes.font_size_8.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            width: AppPadding.padding_6,
                                          ),
                                          Icon(
                                            FlutterRemix.arrow_right_s_line,
                                            color: AppColors.black,
                                            size: AppIconSizes.icon_size_18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: AppMargin.margin_32),
                  ],
                )
              : SizedBox(),

          ///SOCIAL LOGIN BUTTONS ROW
          Platform.isAndroid
              ? isOtherAuthVisible
                  ? Row(
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
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(
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
                    )
                  : SizedBox()
              : Column(
                  children: [
                    Platform.isIOS
                        ? FutureBuilder<bool>(
                            future: SignInWithApple.isAvailable(),
                            builder: (context, snapShot) {
                              if (snapShot.data == null) return SizedBox();
                              if (snapShot.data == false) return SizedBox();
                              return SignUpButton(
                                title: AppLocale.of().continueWithApple,
                                txtColor: ColorMapper.getWhite(),
                                icon: AppAssets.icApple,
                                noBorder: false,
                                isFilled: false,
                                userLoginType: UserLoginType.APPLE,
                                color: ColorMapper.getWhite(),
                                onTap: () {
                                  //LOGIN WITH APPLE
                                  BlocProvider.of<AuthBloc>(context).add(
                                    ContinueWithAppleEvent(),
                                  );
                                },
                              );
                            },
                          )
                        : SizedBox(),
                    SizedBox(height: AppMargin.margin_8),
                    SignUpButton(
                      title: AppLocale.of().continueWithGoogle,
                      txtColor: ColorMapper.getWhite(),
                      icon: AppAssets.icGoogle,
                      userLoginType: UserLoginType.GOOGLE,
                      noBorder: false,
                      isFilled: false,
                      color: ColorMapper.getWhite(),
                      onTap: () {
                        //LOGIN WITH GOOGLE
                        BlocProvider.of<AuthBloc>(context).add(
                          ContinueWithGoogleEvent(),
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_8),
                    SignUpButton(
                      title: AppLocale.of().continueWithFacebook,
                      txtColor: ColorMapper.getWhite(),
                      icon: AppAssets.icFacebook,
                      userLoginType: UserLoginType.FACEBOOK,
                      noBorder: false,
                      isFilled: false,
                      color: ColorMapper.getWhite(),
                      onTap: () {
                        //LOGIN WITH FACEBOOK
                        BlocProvider.of<AuthBloc>(context).add(
                          ContinueWithFacebookEvent(),
                        );
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  buildAppLogo() {
    return Opacity(
      opacity: 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.icAppIconWhite,
            width: AppValues.signUpAppIconSize * 0.3,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: AppPadding.padding_16 * 2,
          ),
          Image.asset(
            AppAssets.icAppWordIconWhite,
            width: AppValues.signUpAppIconSize * 0.7,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Image buildAppLetterLogo() {
    return Image.asset(
      AppAssets.icSplashIcon,
      width: AppValues.signUpAppIconSize,
      fit: BoxFit.contain,
    );
  }
}
