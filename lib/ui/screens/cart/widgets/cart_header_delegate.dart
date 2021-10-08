import 'package:elf_play/config/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartHeaderDelegate extends SliverPersistentHeaderDelegate {
  CartHeaderDelegate({required this.height});

  final double height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
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
                      fontWeight: FontWeight.w600,
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
                      SizedBox(width: AppMargin.margin_8),
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

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
