import 'dart:math';

import 'package:elf_play/config/constants.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ProfilePageHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Container(
      height: 380,
      decoration: BoxDecoration(
        gradient: AppGradients().getProfilePageGradient(AppColors.blue),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Opacity(
                  opacity: shrinkPercentage,
                  child: Container(
                    height: 80,
                    color: AppColors.blue,
                  ),
                ),
                Container(
                  height: 80,
                  child: SafeArea(
                    child: Stack(
                      //  crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              PhosphorIcons.caret_left_light,
                              color: AppColors.white,
                              size: AppIconSizes.icon_size_24,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: shrinkPercentage,
                            child: Text(
                              "abey",
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(AppPadding.padding_4),
                            child: AppBouncingButton(
                              onTap: () {},
                              child: Icon(
                                PhosphorIcons.dots_three_vertical,
                                color: AppColors.white,
                                size: AppIconSizes.icon_size_24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Transform.translate(
              offset: Offset(0, 1 - (shrinkPercentage * 150)),
              child: Transform.scale(
                scale: 1 - shrinkPercentage,
                child: Opacity(
                  opacity: 1 - shrinkPercentage,
                  child: Container(
                    height: 320,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.blue,
                          radius: 50,
                          child: Text(
                            "A",
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_24.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppPadding.padding_16,
                          ),
                          child: Text(
                            "abey",
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_20.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(color: AppColors.white, width: 1),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: AppPadding.padding_4,
                            horizontal: AppPadding.padding_16,
                          ),
                          child: Text(
                            "EDIT PROFILE",
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_8.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 380;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
