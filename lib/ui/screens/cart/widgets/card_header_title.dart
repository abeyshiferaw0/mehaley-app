import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartHeaderTitle extends StatelessWidget {
  const CartHeaderTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
    );
  }
}
