import 'package:country_code_picker/country_code_picker.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/sign_up_page_authing_covor.dart';
import 'package:elf_play/ui/screens/auth/verify_phone/widgets/country_code_picker_button.dart';
import 'package:elf_play/ui/screens/auth/verify_phone/widgets/phone_auth_large_button.dart';
import 'package:elf_play/ui/screens/auth/verify_phone/widgets/phone_number_input.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class VerifyPhonePageOne extends StatefulWidget {
  const VerifyPhonePageOne({Key? key}) : super(key: key);

  @override
  _VerifyPhonePageOneState createState() => _VerifyPhonePageOneState();
}

class _VerifyPhonePageOneState extends State<VerifyPhonePageOne> {
  //FOR PHONE NUMBER VALIDATION
  bool hasError = false;
  MaskedTextController controller =
      new MaskedTextController(mask: '000-000-000');
  CountryCode selectedCountryCode = CountryCode.fromCountryCode("ET");

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
                "phoneNumber": controller.text,
                "countryCode": selectedCountryCode.dialCode,
                "verificationId": state.verificationId,
                "resendToken": state.resendToken,
              },
            ),
          );
          if (isForResend != null) {
            if (isForResend as bool) {
              //RESEND PIN CODE
              BlocProvider.of<AuthBloc>(context).add(
                ContinueWithPhoneEvent(
                  countryCode: selectedCountryCode.dialCode!,
                  phoneNumber: controller.text.replaceAll("-", ""),
                ),
              );
            }
          }
        }
        if (state is PhoneAuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildAppSnackBar(
              bgColor: AppColors.blue,
              txtColor: AppColors.white,
              msg: state.error,
              isFloating: false,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: buildAppBar(context),
        resizeToAvoidBottomInset: false,
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
    );
  }

  Container buildWhatsYourNumberText() {
    return Container(
      margin: EdgeInsets.only(bottom: AppMargin.margin_48),
      child: Text(
        "What is your\nphone number ?".toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_18,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container buildWeTextYouText() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_20,
        horizontal: AppPadding.padding_16,
      ),
      margin: EdgeInsets.only(bottom: AppMargin.margin_16),
      child: Text(
        "We'll' text you a verification code to verify\nyour identity",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12,
          color: AppColors.txtGrey,
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
            text: "Sending SMS",
            onTap: () {},
          );
        } else {
          return PhoneAuthLargeButton(
            isLoading: false,
            disableBouncing: false,
            text: "Send SMS",
            onTap: () {
              //VALIDATE COUNTRY CODE AND PHONE NUMBER
              if (controller.text.length == 11) {
                //LOGIN WITH GOOGLE
                BlocProvider.of<AuthBloc>(context).add(
                  ContinueWithPhoneEvent(
                    countryCode: selectedCountryCode.dialCode!,
                    phoneNumber: controller.text.replaceAll("-", ""),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildAppSnackBar(
                    bgColor: AppColors.errorRed,
                    txtColor: AppColors.white,
                    msg: "Invalid phone number !",
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
            selectedCountryCode = countryCode;
          },
          initialSelection: 'ET',
          favorite: ['ET', 'US'],
          showCountryOnly: true,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
          showFlag: true,
          dialogSize: getCountrySearchDialogSize(context),
          backgroundColor: AppColors.transparent,
          dialogBackgroundColor: AppColors.black,
          barrierColor: AppColors.completelyBlack.withOpacity(0.6),
          closeIcon: Icon(
            PhosphorIcons.x_light,
            size: AppIconSizes.icon_size_24,
            color: AppColors.white,
          ),
          searchStyle: TextStyle(
            color: AppColors.white,
            fontSize: AppFontSizes.font_size_16,
            fontWeight: FontWeight.w600,
          ),
          emptySearchBuilder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.padding_16,
              ),
              child: Center(
                child: Text(
                  "No country found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: AppFontSizes.font_size_14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
          dialogTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: AppFontSizes.font_size_14,
            fontWeight: FontWeight.w500,
          ),
          boxDecoration: BoxDecoration(
            gradient: AppGradients().getCountryDialogGradient(),
          ),
          searchDecoration: InputDecoration(
            prefixIcon: Icon(
              PhosphorIcons.magnifying_glass_light,
              size: AppIconSizes.icon_size_24,
              color: AppColors.darkGreen,
            ),
            fillColor: AppColors.white,
            focusColor: AppColors.white,
            hoverColor: AppColors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkGreen),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkGreen),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.darkGreen),
            ),
            hintText: "Search for country code",
            hintStyle: TextStyle(
              color: AppColors.txtGrey,
              fontSize: AppFontSizes.font_size_14,
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
        )
      ],
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
        "Continue with phone",
        style: TextStyle(
          fontSize: AppFontSizes.font_size_14,
        ),
      ),
    );
  }

  Size getCountrySearchDialogSize(BuildContext context) {
    double screenWidth = ScreenUtil(context: context).getScreenWidth();
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    Size size = Size(screenWidth * 0.95, screenHeight * 0.8);
    return size;
  }
}
