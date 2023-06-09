import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/settings_page_bloc/settings_page_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/settings_page_data.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:sizer/sizer.dart';

class PreferredCurrencyPicker extends StatelessWidget {
  const PreferredCurrencyPicker({
    Key? key,
    required this.settingsPageData,
  }) : super(key: key);

  final SettingsPageData settingsPageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.of().preferredCurrency,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorMapper.getBlack(),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_8,
              ),
              Text(
                AppLocale.of().preferredCurrencySettingMsg,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorMapper.getTxtGrey(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        DropdownButton(
          value: settingsPageData.preferredCurrency,
          dropdownColor: ColorMapper.getLightGrey(),
          focusColor: ColorMapper.getOrange(),
          icon: Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.padding_8,
            ),
            child: Icon(
              FlutterRemix.arrow_down_s_fill,
              size: AppIconSizes.icon_size_16,
              color: ColorMapper.getTxtGrey(),
            ),
          ),
          style: TextStyle(
            color: ColorMapper.getTxtGrey(),
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w400,
          ),
          onChanged: (AppCurrency? value) {},
          items: [
            buildDropdownMenuItem(
              context: context,
              appCurrency: AppCurrency.ETB,
              isActive: settingsPageData.preferredCurrency == AppCurrency.ETB,
            ),
            buildDropdownMenuItem(
              context: context,
              appCurrency: AppCurrency.USD,
              isActive: settingsPageData.preferredCurrency == AppCurrency.USD,
            ),
          ],
        ),
      ],
    );
  }

  DropdownMenuItem<AppCurrency> buildDropdownMenuItem(
      {required AppCurrency appCurrency,
      required bool isActive,
      required BuildContext context}) {
    return DropdownMenuItem<AppCurrency>(
      onTap: () {
        BlocProvider.of<SettingsPageBloc>(context).add(
          ChangePreferredCurrencyEvent(),
        );
      },
      value: appCurrency,
      child: Text(
        EnumToString.convertToString(appCurrency),
        style: TextStyle(
          color:
              isActive ? ColorMapper.getDarkOrange() : ColorMapper.getTxtGrey(),
          fontSize: AppFontSizes.font_size_10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
