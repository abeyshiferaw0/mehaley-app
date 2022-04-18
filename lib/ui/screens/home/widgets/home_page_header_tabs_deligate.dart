import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/ui/screens/home/widgets/home_page_header_tabs.dart';

class HomePageHeaderTabsDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  HomePageHeaderTabsDelegate({required this.tabController});

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return HomePageHeaderTabs(
      tabController: tabController,
      shrinkPercentage: shrinkPercentage,
    );
  }

  @override
  double get maxExtent => AppValues.homePageHeaderTabsHeight;

  @override
  double get minExtent => AppValues.homePageHeaderTabsHeight - 5;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
