import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class ShareBtnWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;

  const ShareBtnWidget({Key? key, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppMargin.margin_20,
          vertical: AppMargin.margin_4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FlutterRemix.share_line,
              size: AppIconSizes.icon_size_12,
              color: color,
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            Text(
              AppLocale.of().share.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                color: color,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
