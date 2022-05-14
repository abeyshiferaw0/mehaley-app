import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_common_toast_widget.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/dialog/payment/phone_verfication/dialog_phone_verfication_page_two.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/country_code_picker_button.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/phone_auth_large_button.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/phone_number_input.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';

class DialogPhoneVerificationPageOne extends StatefulWidget {
  const DialogPhoneVerificationPageOne({
    Key? key,
    this.isForResend,
    this.countryCode,
    this.text,
    required this.onAuthSuccess,
  }) : super(key: key);

  final bool? isForResend;
  final String? countryCode;
  final String? text;
  final VoidCallback onAuthSuccess;

  @override
  _DialogPhoneVerificationPageOneState createState() =>
      _DialogPhoneVerificationPageOneState();
}

class _DialogPhoneVerificationPageOneState
    extends State<DialogPhoneVerificationPageOne> {
  //FOR PHONE NUMBER VALIDATION
  bool hasError = false;
  MaskedTextController controller =
      new MaskedTextController(mask: '000-000-000');
  CountryCode selectedCountryCode = CountryCode.fromCountryCode('ET');

  @override
  void initState() {
    if (widget.isForResend != null) {
      if (widget.isForResend!) {
        ///PRE FILL PHONE INPUT
        controller.text = widget.text!;

        ///RESEND PIN CODE
        BlocProvider.of<AuthBloc>(context).add(
          ContinueWithPhoneEvent(
            countryCode: widget.countryCode!,
            phoneNumber: widget.text!,
          ),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is PhoneAuthCodeSentState) {
          ///CLOSE DIALOG BEFORE PROCEEDING TO PIN INPUT DIALOG
          Navigator.pop(context);

          ///GO TO PIN INPUT DIALOG
          showDialog(
            context: context,
            builder: (context) {
              return DialogPhoneVerificationPageTwo(
                phoneNumber: controller.text,
                verificationId: state.verificationId,
                countryCode: selectedCountryCode.dialCode!,
                onAuthSuccess: widget.onAuthSuccess,
              );
            },
          );
        }
        if (state is PhoneAuthErrorState) {
          ///SHOW ERROR MESSAGE
          showSimpleNotification(
            AppCommonToastWidget(
              bgColor: AppColors.errorRed,
              text: AppLocale.of().authenticationFailedMsg,
              textColor: AppColors.white,
              icon: FlutterRemix.signal_wifi_error_line,
              iconColor: AppColors.white,
            ),
            background: AppColors.transparent,
            contentPadding: EdgeInsets.all(AppPadding.padding_12),
            duration: Duration(seconds: 7),
            elevation: 0,
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
                //color: ColorMapper.getWhite(),
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
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildAuthRequiredText(),
                                    buildWhatsYourNumberText(),
                                    buildPhoneAndCountryCodeInput(context),
                                    buildWeTextYouText(),
                                    buildSendButton(),
                                  ],
                                ),
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

  Container buildAuthRequiredText() {
    return Container(
      margin: EdgeInsets.only(bottom: AppMargin.margin_48),
      child: Text(
        AppLocale.of().phoneNumberRequired.toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          color: ColorMapper.getTxtGrey(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Container buildWhatsYourNumberText() {
    return Container(
      margin: EdgeInsets.only(bottom: AppMargin.margin_48),
      child: Text(
        AppLocale.of().whatIsYourPhoneNumber.toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          color: ColorMapper.getBlack(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container buildWeTextYouText() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_20,
      ),
      margin: EdgeInsets.only(bottom: AppMargin.margin_16),
      child: Text(
        AppLocale.of().phoneVerificationMsg,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          color: ColorMapper.getTxtGrey(),
        ),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> buildSendButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is PhoneAuthLoadingState) {
          return PhoneAuthLargeButton(
            disableBouncing: true,
            isLoading: true,
            text: AppLocale.of().sendingSms,
            onTap: () {},
          );
        } else {
          return PhoneAuthLargeButton(
            isLoading: false,
            disableBouncing: false,
            text: AppLocale.of().sendSms,
            onTap: () {
              //VALIDATE COUNTRY CODE AND PHONE NUMBER
              if (PagesUtilFunctions.validatePhoneByCountryCode(
                  selectedCountryCode.code!, controller.text)) {
                //LOGIN WITH PHONE
                BlocProvider.of<AuthBloc>(context).add(
                  ContinueWithPhoneEvent(
                    countryCode: selectedCountryCode.dialCode!,
                    phoneNumber: controller.text.replaceAll('-', ''),
                  ),
                );
              } else {
                showSimpleNotification(
                  AppCommonToastWidget(
                    bgColor: ColorMapper.getBlack().withOpacity(0.9),
                    text: AppLocale.of().invalidPhoneNumber,
                    textColor: ColorMapper.getWhite(),
                  ),
                  background: AppColors.transparent,
                  contentPadding: EdgeInsets.all(AppPadding.padding_12),
                  duration: Duration(seconds: 7),
                  elevation: 0,
                );
              }
            },
          );
        }
      },
    );
  }

  Row buildPhoneAndCountryCodeInput(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryPickerButton(
          countryCode: CountryCode.fromCountryCode('ET'),
          removeIcon: true,
        ),
        SizedBox(
          width: AppMargin.margin_8,
        ),
        PhoneNumberInput(
          controller: controller,
          hasError: hasError,
          isOnlyEt: true,
          selectedCountryCode: selectedCountryCode,
        )
      ],
    );
  }
}
