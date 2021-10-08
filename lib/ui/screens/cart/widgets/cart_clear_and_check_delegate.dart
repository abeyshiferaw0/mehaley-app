import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ClearAndCheckDelegate extends SliverPersistentHeaderDelegate {
  ClearAndCheckDelegate();

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    var opacityPercentage = shrinkOffset / 120;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkGreen.withOpacity(
          opacityPercentage,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtil.darken(AppColors.darkGreen, 0.3)
                .withOpacity(opacityPercentage),
            AppColors.black,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.padding_8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.white,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      "CLEAR ALL",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppMargin.margin_32,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.padding_8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      "CHECK OUT",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        color: ColorUtil.darken(
                          AppColors.darkGreen,
                          opacityPercentage,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
