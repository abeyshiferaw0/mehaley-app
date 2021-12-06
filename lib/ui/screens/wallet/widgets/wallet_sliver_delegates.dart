import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_header_one.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_header_two.dart';
import 'package:sizer/sizer.dart';

class WalletPageHeadersDelegate extends SliverPersistentHeaderDelegate {
  WalletPageHeadersDelegate(
      {required this.onWalletPageRefresh,
      required this.headerOneHeight,
      required this.headerTwoHeight,
      required this.walletPageData});

  final double headerOneHeight;
  final double headerTwoHeight;
  final WalletPageData walletPageData;
  final VoidCallback onWalletPageRefresh;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Wrap(
      children: [
        Container(
          height: headerTwoHeight + headerOneHeight,
          decoration: BoxDecoration(
            gradient: AppGradients.getWalletHeaderGradient(),
          ),
          child: Column(
            children: [
              WalletHeaderOne(
                height: headerOneHeight,
                walletPageData: walletPageData,
              ),
              WalletHeaderTwo(
                height: headerTwoHeight,
                walletPageData: walletPageData,
                shrinkPercentage: shrinkPercentage,
                onWalletPageRefresh: onWalletPageRefresh,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => headerTwoHeight + headerOneHeight;

  @override
  double get minExtent => headerTwoHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class WalletPageHistoryTitleDelegate extends SliverPersistentHeaderDelegate {
  WalletPageHistoryTitleDelegate({
    required this.height,
  });

  final double height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Wrap(
      children: [
        Container(
          height: height,
          color: AppColors.pagesBgColor,
          child: Center(
            child: Text(
              AppLocale.of().walletHistory.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                letterSpacing: 0.5,
              ),
            ),
          ),
        )
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
