import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class LibraryErrorWidget extends StatelessWidget {
  const LibraryErrorWidget({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().somethingWentWrong,
              style: TextStyle(
                color: ColorMapper.getBlack(),
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_8,
            ),
            Text(
              AppLocale.of().checkYourInternetConnection,
              style: TextStyle(
                color: ColorMapper.getDarkGrey(),
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            AppBouncingButton(
              onTap: () {
                onRetry();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_32,
                  vertical: AppPadding.padding_8,
                ),
                decoration: BoxDecoration(
                  color: ColorMapper.getBlack(),
                  borderRadius: BorderRadius.circular(120),
                ),
                child: Text(
                  AppLocale.of().tryAgain,
                  style: TextStyle(
                    color: ColorMapper.getWhite(),
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
