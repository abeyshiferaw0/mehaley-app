import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class SearchEmptyMessage extends StatelessWidget {
  const SearchEmptyMessage({required this.searchKey});

  final String searchKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().cantFind(searchKey: searchKey),
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.font_size_12.sp,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_8,
            ),
            Text(
              AppLocale.of().changeYourSearchKey,
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
