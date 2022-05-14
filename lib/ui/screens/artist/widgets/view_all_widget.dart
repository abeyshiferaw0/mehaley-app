import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppPadding.padding_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of().viewMore.toUpperCase(),
              style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: ColorMapper.getDarkOrange(),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: AppMargin.margin_2,
            ),
            Icon(
              FlutterRemix.arrow_right_s_line,
              size: AppIconSizes.icon_size_16,
              color: ColorMapper.getDarkOrange(),
            )
          ],
        ),
      ),
    );
  }
}
