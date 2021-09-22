import 'dart:math';

import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:flutter/cupertino.dart';

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
