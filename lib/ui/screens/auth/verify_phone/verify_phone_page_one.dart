import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/sign_up_page_authing_covor.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/country_code_picker_button.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/phone_auth_large_button.dart';
import 'package:mehaley/ui/screens/auth/verify_phone/widgets/phone_number_input.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class VerifyPhonePageOne extends StatefulWidget {
  const VerifyPhonePageOne({Key? key}) : super(key: key);

  @override
  _VerifyPhonePageOneState createState() => _VerifyPhonePageOneState();
}

class _VerifyPhonePageOneState extends State<VerifyPhonePageOne> {
  //FOR PHONE NUMBER VALIDATION
  bool hasError = false;
  MaskedTextController controller =
      new MaskedTextController(mask: '000-000-0000');
  CountryCode selectedCountryCode = CountryCode.fromCountryCode('ET');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is PhoneAuthCodeSentState) {
          final isForResend = await Navigator.pushNamed(
            context,
            AppRouterPaths.verifyPhonePageTwo,
            arguments: ScreenArguments(
              args: {
                'phoneNumber': controller.text,
                'countryCode': selectedCountryCode.dialCode,
                'verificationId': state.verificationId,
                'resendToken': state.resendToken,
              },
            ),
          );
          if (isForResend != null) {
            if (isForResend as bool) {
              //RESEND PIN CODE
              BlocProvider.of<AuthBloc>(context).add(
                ContinueWithPhoneEvent(
                  countryCode: selectedCountryCode.dialCode!,
                  phoneNumber: controller.text.replaceAll('-', ''),
                ),
              );
            }
          }
        }
        if (state is PhoneAuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildAppSnackBar(
              bgColor: ColorMapper.getBlack().withOpacity(0.9),
              txtColor: ColorMapper.getWhite(),
              msg: state.error,
              isFloating: false,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorMapper.getPagesBgColor(),
        appBar: buildAppBar(context),
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
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
                    buildWhatsYourNumberText(),
                    buildPhoneAndCountryCodeInput(context),
                    buildWeTextYouText(),
                    buildSendButton(),
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is PhoneAuthLoadingState) {
                    return SignUpPageAuthingCovor(
                      showLoading: false,
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
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
          fontSize: AppFontSizes.font_size_14.sp,
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
              } else if (selectedCountryCode.code != 'ET' &&
                  controller.text.length == 12) {
                //LOGIN WITH GOOGLE
                BlocProvider.of<AuthBloc>(context).add(
                  ContinueWithPhoneEvent(
                    countryCode: selectedCountryCode.dialCode!,
                    phoneNumber: controller.text.replaceAll('-', ''),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildAppSnackBar(
                    bgColor: ColorMapper.getBlack().withOpacity(0.9),
                    txtColor: ColorMapper.getWhite(),
                    msg: AppLocale.of().invalidPhoneNumber,
                    isFloating: false,
                  ),
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
        CountryCodePicker(
          onChanged: (CountryCode countryCode) {
            setState(() {
              selectedCountryCode = countryCode;
            });
          },
          initialSelection: 'ET',
          favorite: ['ET', 'US'],
          showCountryOnly: true,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
          showFlag: true,
          dialogSize: getCountrySearchDialogSize(context),
          backgroundColor: ColorMapper.getCompletelyBlack().withOpacity(0.4),
          dialogBackgroundColor: ColorMapper.getWhite(),
          barrierColor: ColorMapper.getCompletelyBlack().withOpacity(0.3),
          closeIcon: Icon(
            FlutterRemix.close_line,
            size: AppIconSizes.icon_size_24,
            color: ColorMapper.getBlack(),
          ),
          searchStyle: TextStyle(
            color: ColorMapper.getBlack(),
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
          ),
          emptySearchBuilder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.padding_16,
              ),
              child: Center(
                child: Text(
                  AppLocale.of().noCountryCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorMapper.getGrey(),
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
          dialogTextStyle: TextStyle(
            color: ColorMapper.getBlack(),
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w500,
          ),
          searchDecoration: InputDecoration(
            prefixIcon: Icon(
              FlutterRemix.search_line,
              size: AppIconSizes.icon_size_24,
              color: ColorMapper.getDarkOrange(),
            ),
            fillColor: ColorMapper.getBlack(),
            focusColor: ColorMapper.getBlack(),
            hoverColor: ColorMapper.getBlack(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorMapper.getDarkOrange()),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorMapper.getDarkOrange()),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorMapper.getDarkOrange()),
            ),
            hintText: AppLocale.of().searchForCountryCode,
            hintStyle: TextStyle(
              color: ColorMapper.getTxtGrey(),
              fontSize: AppFontSizes.font_size_10.sp,
            ),
          ),
          flagWidth: 18,
          builder: (countryCode) {
            if (countryCode != null)
              return CountryPickerButton(
                countryCode: countryCode,
              );
          },
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        PhoneNumberInput(
          controller: controller,
          hasError: hasError,
          selectedCountryCode: selectedCountryCode,
        )
      ],
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
        AppLocale.of().continueWithPhoneNumber,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          color: ColorMapper.getBlack(),
        ),
      ),
    );
  }

  Size getCountrySearchDialogSize(BuildContext context) {
    double screenWidth = ScreenUtil(context: context).getScreenWidth();
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    Size size = Size(screenWidth * 0.8, screenHeight * 0.7);
    return size;
  }
}
