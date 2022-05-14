import 'package:country_code_picker/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class PhoneNumberInput extends StatefulWidget {
  PhoneNumberInput({
    Key? key,
    required this.controller,
    required this.hasError,
    this.isOnlyEt,
    required this.selectedCountryCode,
  }) : super(key: key);

  final MaskedTextController controller;
  final bool hasError;
  final CountryCode selectedCountryCode;
  final bool? isOnlyEt;

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  ///
  bool readOnly = false;

  final String etCode = 'ET';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is PhoneAuthLoadingState)
          readOnly = true;
        else
          readOnly = false;

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TextFormField(
                  controller: widget.controller,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  cursorColor: ColorMapper.getDarkOrange(),
                  onChanged: (key) {},
                  maxLength:
                      PagesUtilFunctions.getPhoneInputLengthByCountryCode(
                    widget.selectedCountryCode.code!,
                  ),
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '';
                    } else {
                      if (PagesUtilFunctions.validatePhoneByCountryCode(
                          widget.selectedCountryCode.code!, text)) {
                        return null;
                      } else {
                        return AppLocale.of().invalidPhoneNumber;
                      }
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    color: readOnly
                        ? ColorMapper.getTxtGrey()
                        : ColorMapper.getBlack(),
                    fontSize: AppFontSizes.font_size_14,
                    fontWeight: FontWeight.w600,
                  ),
                  buildCounter: (
                    context, {
                    required currentLength,
                    maxLength,
                    required isFocused,
                  }) =>
                      Text(
                    '$currentLength/$maxLength',
                    style: TextStyle(
                      color: ColorMapper.getDarkOrange(),
                      fontSize: AppFontSizes.font_size_10,
                    ),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding_8,
                      vertical: AppPadding.padding_16,
                    ),
                    errorStyle: TextStyle(
                      fontSize: AppFontSizes.font_size_10,
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w400,
                    ),
                    errorText: '',
                    filled: true,
                    fillColor: ColorMapper.getLightGrey(),
                    border: InputBorder.none,
                    focusColor: ColorMapper.getOrange(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    //hintText: AppLocale.of().enterYourPhoneNumber,
                    hintText: getHint(widget.isOnlyEt),
                    hintStyle: TextStyle(
                      color: ColorMapper.getTxtGrey(),
                      fontSize: AppFontSizes.font_size_14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Visibility(
                visible: widget.hasError,
                child: Text(
                  AppLocale.of().invalidPhoneNumber,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.errorRed,
                    fontSize: AppFontSizes.font_size_12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getHint(bool? isOnlyEt) {
    if (isOnlyEt != null) {
      if (isOnlyEt) {
        return '9xx-xxx-xxx';
      }
    }
    return AppLocale.of().enterYourPhoneNumber;
  }
}
