import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class LanguageSettingItem extends StatelessWidget {
  const LanguageSettingItem({
    Key? key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      shrinkRatio: 6,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppMargin.margin_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              FlutterRemix.checkbox_circle_fill,
              color: isSelected
                  ? ColorMapper.getDarkOrange()
                  : ColorMapper.getDarkGrey(),
              size: AppIconSizes.icon_size_20,
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? ColorMapper.getDarkOrange()
                    : ColorMapper.getDarkGrey(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
