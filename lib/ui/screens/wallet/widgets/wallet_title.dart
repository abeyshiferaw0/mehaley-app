import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class WalletTitle extends StatelessWidget {
  const WalletTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      color: AppColors.pagesBgColor,
      child: Center(
        child: Text(
          "Wallet History".toUpperCase(),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
