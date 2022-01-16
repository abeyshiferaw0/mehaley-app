import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class IapVerificationErrorWidget extends StatelessWidget {
  const IapVerificationErrorWidget({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: AppMargin.margin_16,
            ),
            Text(
              "Your Purchase Could Not Be Completed",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_4,
            ),
            Text(
              AppLocale.of().checkYourInternetConnection,
              style: TextStyle(
                color: AppColors.txtGrey,
                fontWeight: FontWeight.w500,
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
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(120),
                ),
                child: Text(
                  AppLocale.of().tryAgain,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppMargin.margin_20,
            ),
          ],
        ),
      ),
    );
  }
}
