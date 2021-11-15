import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

import 'app_bouncing_button.dart';
import 'app_gradients.dart';

class AppSubscribeCard extends StatelessWidget {
  const AppSubscribeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_16,
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.getOfflineLibraryGradient(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocale.of().subscribeDialogTitle.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_8,
          ),
          Text(
            AppLocale.of().subscribeDialogMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          AppBouncingButton(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_32,
                vertical: AppPadding.padding_8,
              ),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    color: AppColors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Text(
                AppLocale.of().subscribeNow.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
