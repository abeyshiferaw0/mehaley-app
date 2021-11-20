import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class PlayShuffleLgBtnWidget extends StatelessWidget {
  final VoidCallback onTap;

  const PlayShuffleLgBtnWidget({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        height: AppIconSizes.icon_size_40,
        decoration: BoxDecoration(
          color: AppColors.darkOrange,
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              color: AppColors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_24,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                FlutterRemix.shuffle_line,
                color: AppColors.lightGrey,
                size: AppIconSizes.icon_size_12,
              ),
              SizedBox(
                width: AppMargin.margin_32,
              ),
              Text(
                AppLocale.of().play.toUpperCase(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightGrey,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
