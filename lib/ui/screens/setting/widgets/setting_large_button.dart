import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class SettingLargeButton extends StatelessWidget {
  const SettingLargeButton({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      shrinkRatio: 6,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_8,
                ),
                Text(
                  subTitle,
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
          Icon(
            FlutterRemix.arrow_right_s_line,
            color: AppColors.darkGrey,
            size: AppIconSizes.icon_size_24,
          ),
        ],
      ),
    );
  }
}
