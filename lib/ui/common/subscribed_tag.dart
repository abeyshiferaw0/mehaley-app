import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class SubscribedTag extends StatelessWidget {
  SubscribedTag({Key? key, required this.bgColor, required this.txtColor}) : super(key: key);

  ///IS USER SUBSCRIBED
  final bool isUsersSubscribed = PagesUtilFunctions.isUserSubscribed();

  final Color bgColor;

  final Color txtColor;

  @override
  Widget build(BuildContext context) {
    if (isUsersSubscribed) {
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.padding_12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: bgColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(100.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
                vertical: AppPadding.padding_6,
              ),
              child: Text(
                AppLocale.of().subscribed.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: (AppFontSizes.font_size_6+1).sp,
                  color: txtColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
