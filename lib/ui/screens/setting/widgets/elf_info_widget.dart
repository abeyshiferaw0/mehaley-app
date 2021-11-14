import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ElfInfoWidget extends StatelessWidget {
  const ElfInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppMargin.margin_20),
      child: Column(
        children: [
          Text(
            AppLocale.of().appName,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Text(
            AppLocale.of().appVersion,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Text(
            AppLocale.of().appTermsAndCondition,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
        ],
      ),
    );
  }
}
