import 'dart:math';

import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfilePageTabsDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  ProfilePageTabsDelegate({required this.height});

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_32,
        vertical: AppPadding.padding_4,
      ),
      height: height,
      color: AppColors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildProfileTab(number: "4", title: "purchases"),
          buildProfileTab(number: "0", title: "downloads"),
          buildProfileTab(number: "3", title: "following"),
        ],
      ),
    );
  }

  Column buildProfileTab({required String number, required String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_4,
        ),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            letterSpacing: 0.8,
            fontSize: AppFontSizes.font_size_8.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.txtGrey,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
