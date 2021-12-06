import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

import '../../../app_bouncing_button.dart';

class PaymentButtonText extends StatelessWidget {
  const PaymentButtonText({Key? key, required this.title, required this.onTap})
      : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_32,
          vertical: AppPadding.padding_8,
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_8.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
