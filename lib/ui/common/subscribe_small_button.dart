import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class SubscribeSmallButton extends StatelessWidget {
  SubscribeSmallButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.textColor,
    required this.fontSize,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;
  final Color textColor;
  final double fontSize;

  final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
  final bool isIapAvailable = PagesUtilFunctions.isIapAvailable();

  @override
  Widget build(BuildContext context) {
    if (isUserSubscribed || !isIapAvailable) {
      return SizedBox();
    } else {
      return AppBouncingButton(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
