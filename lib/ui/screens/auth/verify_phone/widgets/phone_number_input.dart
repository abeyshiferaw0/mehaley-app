import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class PhoneNumberInput extends StatelessWidget {
  PhoneNumberInput({
    Key? key,
    required this.controller,
    required this.hasError,
  }) : super(key: key);

  final MaskedTextController controller;
  final bool hasError;

  ///
  bool readOnly = false;

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
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: true,
                  cursorColor: AppColors.darkGreen,
                  onChanged: (key) {},
                  maxLength: 11,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '';
                    } else {
                      if (text.length < 11)
                        return AppLocale.of().invalidPhoneNumber;
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    color: readOnly ? AppColors.txtGrey : AppColors.white,
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
                      color: AppColors.darkGreen,
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
                    filled: true,
                    fillColor: AppColors.darkGrey,
                    border: InputBorder.none,
                    focusColor: AppColors.green,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: AppLocale.of().enterYourPhoneNumber,
                    hintStyle: TextStyle(
                      color: AppColors.txtGrey,
                      fontSize: AppFontSizes.font_size_14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Visibility(
                visible: hasError,
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
}
