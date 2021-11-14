import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/enums/user_login_type.dart';
import 'package:elf_play/ui/screens/auth/widgets/sign_up_page_button.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPageFront extends StatelessWidget {
  const SignUpPageFront({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(AppPadding.padding_28),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: ScreenUtil(context: context).getScreenHeight(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: AppMargin.margin_28,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.white,
                      child: Text('ELF'),
                    ),
                    SizedBox(
                      height: AppMargin.margin_16,
                    ),
                    Text(
                      AppLocale.of().appName,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_16,
                    ),
                    Text(
                      AppLocale.of().appWelcomeTxt,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_52,
                    ),
                  ],
                ),
              ),
              //Expanded(child: SizedBox()),
              SizedBox(
                height: AppMargin.margin_48,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: AppMargin.margin_16),
                    SignUpButton(
                      title: AppLocale.of().continueWithPhone,
                      icon: 'assets/icons/ic_phone.svg',
                      userLoginType: UserLoginType.PHONE_NUMBER,
                      color: AppColors.darkGreen,
                      isFilled: true,
                      noBorder: false,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterPaths.verifyPhonePageOne,
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_12),
                    SignUpButton(
                      title: AppLocale.of().continueWithGoogle,
                      icon: 'assets/icons/ic_google.svg',
                      userLoginType: UserLoginType.GOOGLE,
                      color: AppColors.grey,
                      isFilled: false,
                      noBorder: false,
                      onTap: () {
                        //LOGIN WITH GOOGLE
                        BlocProvider.of<AuthBloc>(context).add(
                          ContinueWithGoogleEvent(),
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_12),
                    SignUpButton(
                      title: AppLocale.of().continueWithFacebook,
                      icon: 'assets/icons/ic_facebook.svg',
                      userLoginType: UserLoginType.FACEBOOK,
                      color: AppColors.grey,
                      isFilled: false,
                      noBorder: false,
                      onTap: () {
                        //LOGIN WITH FACEBOOK
                        BlocProvider.of<AuthBloc>(context).add(
                          ContinueWithFacebookEvent(),
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_12),
                    SignUpButton(
                      title: AppLocale.of().continueWithApple,
                      icon: 'assets/icons/ic_apple.svg',
                      userLoginType: UserLoginType.APPLE,
                      color: AppColors.grey,
                      isFilled: false,
                      noBorder: false,
                      onTap: () {},
                    ),
                    SizedBox(height: AppMargin.margin_12),
                    // SignUpButton(
                    //   title: 'login',
                    //   userLoginType: UserLoginType.NONE,
                    //   color: AppColors.grey,
                    //   isFilled: false,
                    //   noBorder: true,
                    //   onTap: () {},
                    // ),
                    SizedBox(height: AppMargin.margin_16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
