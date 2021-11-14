import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/sign_up_page_authing_covor.dart';
import 'package:elf_play/ui/screens/auth/verify_phone/widgets/phone_auth_large_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:pinput/pin_put/pin_put.dart';

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
              bgColor: AppColors.blue,
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
        backgroundColor: AppColors.black,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            Container(
              color: AppColors.black,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
                vertical: AppPadding.padding_28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                                bgColor: AppColors.blue,
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
            fontSize: AppFontSizes.font_size_12,
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
                fontSize: AppFontSizes.font_size_12,
                color: AppColors.darkGreen,
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
        horizontal: AppPadding.padding_16,
      ),
      child: Text(
        '${AppLocale.of().enterSixDigitMenu}${args.args['countryCode']}-${args.args['phoneNumber']}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12,
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
        fontSize: AppFontSizes.font_size_18,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.black,
      shadowColor: AppColors.transparent,
      centerTitle: true,
      //brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: AppIconSizes.icon_size_24,
        color: AppColors.white,
        icon: Icon(
          PhosphorIcons.caret_left_light,
        ),
      ),
      title: Text(
        AppLocale.of().verifyYourPhone,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_14,
        ),
      ),
    );
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: AppColors.darkGrey,
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
            color: AppColors.darkGreen,
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
        textStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
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
