import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:sizer/sizer.dart';

import 'app_bouncing_button.dart';

class SliverSmallTextButton extends StatelessWidget {
  const SliverSmallTextButton({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.onTap,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: ColorUtil.darken(AppColors.white, 0.1),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: AppMargin.margin_16),
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
            SizedBox(width: AppMargin.margin_8),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.font_size_8.sp - 1,
              ),
            ),
            SizedBox(width: AppMargin.margin_16),
          ],
        ),
      ),
    );
  }
}
