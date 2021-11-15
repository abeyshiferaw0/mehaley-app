import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/category.dart';

import 'category_page_header.dart';

class CategorySliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Category category;

  CategorySliverHeaderDelegate({required this.category});

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return CategoryPageHeader(
      shrinkPercentage: shrinkPercentage,
      category: category,
    );
  }

  @override
  double get maxExtent => AppValues.categoryHeaderHeight;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
