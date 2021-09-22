import 'package:country_code_picker/country_code.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class CountryPickerButton extends StatelessWidget {
  const CountryPickerButton({
    Key? key,
    required this.countryCode,
  }) : super(key: key);

  final CountryCode countryCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGrey,
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: AppMargin.margin_12,
          ),
          Container(
            width: AppIconSizes.icon_size_20,
            height: AppIconSizes.icon_size_20,
            child: Image(
              image: AssetImage(
                countryCode.flagUri!,
                package: 'country_code_picker',
              ),
            ),
          ),
          SizedBox(
            width: AppMargin.margin_8,
          ),
          Text(
            "$countryCode",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: AppMargin.margin_4,
          ),
          Icon(
            PhosphorIcons.caret_down_fill,
            size: AppFontSizes.font_size_12,
            color: AppColors.white,
          ),
          SizedBox(
            width: AppMargin.margin_8,
          ),
        ],
      ),
    );
  }
}
