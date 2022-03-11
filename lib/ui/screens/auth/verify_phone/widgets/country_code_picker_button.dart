import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';

class CountryPickerButton extends StatelessWidget {
  const CountryPickerButton({
    Key? key,
    required this.countryCode,
  }) : super(key: key);

  final CountryCode countryCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorMapper.getLightGrey(),
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
            '$countryCode',
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12,
              color: ColorMapper.getBlack(),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: AppMargin.margin_4,
          ),
          Icon(
            FlutterRemix.arrow_down_s_fill,
            size: AppFontSizes.font_size_12,
            color: ColorMapper.getBlack(),
          ),
          SizedBox(
            width: AppMargin.margin_8,
          ),
        ],
      ),
    );
  }
}
