import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/sign_up_page_authing_covor.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/phone_auth_large_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sizer/sizer.dart';

class VerifyPhonePageTwo extends StatefulWidget {
  const VerifyPhonePageTwo({Key? key}) : super(key: key);

  @override
  _VerifyPhonePageTwoState createState() => _VerifyPhonePageTwoState();
}

class _VerifyPhonePageTwoState extends State<VerifyPhonePageTwo> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  late String verificationId;
  int? resendToken;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    verificationId = args.args['verificationId'];
    resendToken = args.args['resendToken'];
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LastSmsStillActiveState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildAppSnackBar(
              bgColor: AppColors.black.withOpacity(0.9),
              txtColor: AppColors.white,
              msg: AppLocale.of().pinAlreadySent,
              isFloating: false,
            ),
          );
        }
        if (state is ResendCodeState) {
          Navigator.pop(context, true);
        }
        if (state is AuthSuccessState) {
          Navigator.pushNamedAndRemoveUntil(context, AppRouterPaths.mainScreen,
              ModalRoute.withName(AppRouterPaths.splashRoute));
        }
        if (state is AuthErrorState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
                vertical: AppPadding.padding_28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEnterYourCodeText(),
                  buildHintText(args),
                  darkRoundedPinPut(),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is PhoneAuthLoadingState) {
                        return PhoneAuthLargeButton(
                          disableBouncing: true,
                          isLoading: true,
                          text: AppLocale.of().verifying,
                          onTap: () {},
                        );
                      }
                      return PhoneAuthLargeButton(
                        disableBouncing: false,
                        isLoading: false,
                        text: AppLocale.of().verify,
                        onTap: () {
                          //VERIFY PIN CODE
                          if (_pinPutController.text.length == 6) {
                            BlocProvider.of<AuthBloc>(context).add(
                              VerifyPhoneEvent(
                                pinCode: _pinPutController.text,
                                verificationId: verificationId,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildAppSnackBar(
                                bgColor: AppColors.black.withOpacity(0.9),
                                txtColor: AppColors.white,
                                msg: AppLocale.of().pinNotFilled,
                                isFloating: false,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  buildCantReciveSms(context, args)
                ],
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is PhoneAuthLoadingState) {
                  return SignUpPageAuthingCovor(
                    showLoading: true,
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row buildCantReciveSms(BuildContext context, ScreenArguments args) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocale.of().didntReciveSms,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_8.sp,
            color: AppColors.txtGrey,
          ),
        ),
        SizedBox(
          width: AppMargin.margin_8,
        ),
        AppBouncingButton(
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(
              ResendPinCodeEvent(
                resendToken: resendToken,
                phoneNumber:
                    '${args.args['countryCode']}${(args.args['phoneNumber'] as String).replaceAll('-', '')}',
              ),
            );
          },
          shrinkRatio: 9,
          child: Text(
            AppLocale.of().resendCode,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                color: AppColors.darkOrange,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Container buildHintText(ScreenArguments args) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_20 * 2,
      ),
      child: Text(
        '${AppLocale.of().enterSixDigitMenu} ${args.args['countryCode']}-${args.args['phoneNumber']}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          color: AppColors.txtGrey,
        ),
      ),
    );
  }

  Text buildEnterYourCodeText() {
    return Text(
      '${AppLocale.of().enterYourCode}'.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_14.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      shadowColor: AppColors.transparent,
      centerTitle: false,
      //brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: AppIconSizes.icon_size_24,
        color: AppColors.black,
        icon: Icon(
          FlutterRemix.arrow_left_line,
        ),
      ),
      title: Text(
        AppLocale.of().verifyYourPhone,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(4.0),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
      child: PinPut(
        eachFieldWidth: 50.0,
        eachFieldHeight: 50.0,
        withCursor: true,
        cursor: Container(
          height: 20,
          width: 2,
          decoration: BoxDecoration(
            color: AppColors.darkOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        fieldsCount: 6,
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: pinPutDecoration,
        selectedFieldDecoration: pinPutDecoration,
        followingFieldDecoration: pinPutDecoration,
        autofocus: true,
        pinAnimationType: PinAnimationType.scale,
        textStyle: TextStyle(color: AppColors.black, fontSize: 20.0),
        onSubmit: (pin) {
          // BlocProvider.of<AuthBloc>(context).add(
          //   VerifyPhoneEvent(
          //     pinCode: _pinPutController.text,
          //     verificationId: verificationId,
          //   ),
          // );
        },
      ),
    );
  }
}
