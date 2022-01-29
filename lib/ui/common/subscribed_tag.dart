import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class SubscribedTag extends StatelessWidget {
  SubscribedTag({Key? key, required this.color}) : super(key: key);

  ///IS USER SUBSCRIBED
  final bool isUsersSubscribed = PagesUtilFunctions.isUserSubscribed();

  final Color color;

  @override
  Widget build(BuildContext context) {
    if (isUsersSubscribed) {
      return Padding(
        padding: const EdgeInsets.only(
          left: AppPadding.padding_8,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(
              color: color,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(100.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_16,
            vertical: AppPadding.padding_4,
          ),
          child: Text(
            AppLocale.of().subscribed.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_6.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
