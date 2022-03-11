import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

import '../../../app_bouncing_button.dart';

class PaymentButtonFilled extends StatelessWidget {
  const PaymentButtonFilled(
      {Key? key, required this.title, required this.onTap})
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
          vertical: AppPadding.padding_6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: ColorMapper.getOrange(),
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
            color: ColorMapper.getWhite(),
          ),
        ),
      ),
    );
  }
}
