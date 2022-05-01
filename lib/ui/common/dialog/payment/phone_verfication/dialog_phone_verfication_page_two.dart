import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/phone_auth_large_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sizer/sizer.dart';

import 'dialog_phone_verfication_page_one.dart';

class DialogPhoneVerificationPageTwo extends StatefulWidget {
  const DialogPhoneVerificationPageTwo({
    Key? key,
    required this.verificationId,
    this.resendToken,
    required this.countryCode,
    required this.phoneNumber,
    required this.onAuthSuccess,
  }) : super(key: key);

  final String verificationId;
  final int? resendToken;
  final VoidCallback onAuthSuccess;
  final String countryCode;
  final String phoneNumber;

  @override
  _DialogPhoneVerificationPageTwoState createState() =>
      _DialogPhoneVerificationPageTwoState();
}

class _DialogPhoneVerificationPageTwoState
    extends State<DialogPhoneVerificationPageTwo> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LastSmsStillActiveState) {
          ///SHOW VERIFYING LAST SMS IS RECENT MSG
          ScaffoldMessenger.of(context).showSnackBar(
            buildAppSnackBar(
              bgColor: ColorMapper.getBlack().withOpacity(0.9),
              txtColor: ColorMapper.getWhite(),
              msg: AppLocale.of().pinAlreadySent,
              isFloating: false,
            ),
          );
        }
        if (state is ResendCodeState) {
          ///POP THIS DIALOG FIRST
          Navigator.pop(context);

          /// RESEND PIN CODE
          showDialog(
            context: context,
            builder: (context) {
              return DialogPhoneVerificationPageOne(
                isForResend: true,
                countryCode: widget.countryCode,
                text: widget.phoneNumber,
                onAuthSuccess: widget.onAuthSuccess,
              );
            },
          );
        }
        if (state is AuthSuccessState) {
          ///POP THIS DIALOG FIRST
          Navigator.pop(context);

          ///RESUME PAYMENT PROCESS
          widget.onAuthSuccess();
        }
        if (state is AuthErrorState) {
          ///POP THIS DIALOG FIRST
          Navigator.pop(context);

          ///GO TO PHONE INPUT DIALOG
          showDialog(
            context: context,
            builder: (context) {
              return DialogPhoneVerificationPageOne(
                onAuthSuccess: widget.onAuthSuccess,
              );
            },
          );
        }
      },
      child: Center(
        child: AppCard(
          radius: 6,
          child: Wrap(
            children: [
              Container(
                width: ScreenUtil(context: context).getScreenWidth() * 0.9,
                height: ScreenUtil(context: context).getScreenHeight() * 0.6,
                child: Material(
                  child: Column(
                    children: [
                      AppTopHeaderWithIcon(enableCloseWarning: true),
                      Expanded(
                        child: Stack(
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
                                  buildHintText(),
                                  darkRoundedPinPut(),
                                  SizedBox(
                                    height: AppMargin.margin_48,
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
                                          if (_pinPutController.text.length ==
                                              6) {
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(
                                              VerifyPhoneEvent(
                                                pinCode: _pinPutController.text,
                                                verificationId:
                                                    widget.verificationId,
                                                isForEthioTelePaymentAuth: true,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              buildAppSnackBar(
                                                bgColor: ColorMapper.getBlack()
                                                    .withOpacity(0.9),
                                                txtColor:
                                                    ColorMapper.getWhite(),
                                                msg:
                                                    AppLocale.of().pinNotFilled,
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
                                  buildCantReciveSms(context),
                                ],
                              ),
                            ),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is PhoneAuthLoadingState) {
                                  return buildLoading();
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Container(
      color: ColorMapper.getCompletelyBlack().withOpacity(0.5),
      child: Center(
        child: AppLoading(
          size: AppValues.loadingWidgetSize * 0.8,
        ),
      ),
    );
  }

  Row buildCantReciveSms(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocale.of().didntReciveSms,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_8.sp,
            color: ColorMapper.getTxtGrey(),
          ),
        ),
        SizedBox(
          width: AppMargin.margin_8,
        ),
        AppBouncingButton(
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(
              ResendPinCodeEvent(
                resendToken: widget.resendToken,
                phoneNumber:
                    '${widget.countryCode}${widget.phoneNumber.replaceAll('-', '')}',
              ),
            );
          },
          shrinkRatio: 9,
          child: Text(
            AppLocale.of().resendCode,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                color: ColorMapper.getDarkOrange(),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Container buildHintText() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_20 * 2,
      ),
      child: Text(
        '${AppLocale.of().enterSixDigitMenu} ${widget.countryCode}-${widget.phoneNumber}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          color: ColorMapper.getTxtGrey(),
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
        color: ColorMapper.getBlack(),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorMapper.getWhite(),
      shadowColor: AppColors.transparent,
      centerTitle: false,
      //brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: AppIconSizes.icon_size_24,
        color: ColorMapper.getBlack(),
        icon: Icon(
          FlutterRemix.arrow_left_line,
        ),
      ),
      title: Text(
        AppLocale.of().verifyYourPhone,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          color: ColorMapper.getBlack(),
        ),
      ),
    );
  }

  Widget darkRoundedPinPut() {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: ColorMapper.getLightGrey(),
      borderRadius: BorderRadius.circular(4.0),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.padding_4,
      ),
      child: PinPut(
        eachFieldWidth: 40.0,
        eachFieldHeight: 40.0,
        withCursor: true,
        cursor: Container(
          height: 20,
          width: 2,
          decoration: BoxDecoration(
            color: ColorMapper.getDarkOrange(),
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
        textStyle: TextStyle(color: ColorMapper.getBlack(), fontSize: 20.0),
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
