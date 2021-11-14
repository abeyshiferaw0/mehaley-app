import 'package:elf_play/business_logic/blocs/settings_page_bloc/settings_page_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/api_response/settings_page_data.dart';
import 'package:elf_play/data/models/enums/setting_enums/app_currency.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
                AppLocalizations.of(context)!.preferredCurrency,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_8,
              ),
              Text(
                AppLocalizations.of(context)!.preferredCurrencySettingMsg,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.txtGrey,
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
          dropdownColor: AppColors.darkGrey,
          focusColor: AppColors.green,
          icon: Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.padding_8,
            ),
            child: Icon(
              PhosphorIcons.caret_down_fill,
              size: AppIconSizes.icon_size_16,
              color: AppColors.txtGrey,
            ),
          ),
          style: TextStyle(
            color: AppColors.txtGrey,
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
          color: isActive ? AppColors.darkGreen : AppColors.txtGrey,
          fontSize: AppFontSizes.font_size_10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
