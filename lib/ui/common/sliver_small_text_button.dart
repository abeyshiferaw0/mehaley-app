import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
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
        height: AppIconSizes.icon_size_40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: AppColors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
