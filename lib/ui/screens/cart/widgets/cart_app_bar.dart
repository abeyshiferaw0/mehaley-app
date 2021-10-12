import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: AppColors.black,
      child: SafeArea(
        child: Container(
          color: AppColors.darkGrey,
          padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Elf Cart",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: AppMargin.margin_4),
                      Icon(
                        Icons.circle,
                        color: AppColors.white,
                        size: AppIconSizes.icon_size_4,
                      ),
                      SizedBox(width: AppMargin.margin_4),
                      Text(
                        "300 ETB",
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
