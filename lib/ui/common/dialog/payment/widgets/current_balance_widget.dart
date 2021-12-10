import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/date_util_extention.dart';
import 'package:sizer/sizer.dart';

class CurrentBallanceWidget extends StatelessWidget {
  const CurrentBallanceWidget({Key? key, required this.balance})
      : super(key: key);

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of().yourCurrentBalance,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_8.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(
          height: AppPadding.padding_4,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: balance.parsePriceAmount(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkOrange,
            ),
            children: [
              TextSpan(
                text: ' ${AppLocale.of().birr}',
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.txtGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
