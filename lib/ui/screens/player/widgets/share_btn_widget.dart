import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class ShareBtnWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_20,
        vertical: AppMargin.margin_4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.white, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FlutterRemix.share_line,
            size: AppIconSizes.icon_size_12,
            color: AppColors.white,
          ),
          SizedBox(
            width: AppMargin.margin_8,
          ),
          Text(
            AppLocale.of().share.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              color: AppColors.white,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
