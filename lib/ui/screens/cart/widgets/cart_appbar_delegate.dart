import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_app_bar.dart';

class CartAppBarDelegate extends SliverPersistentHeaderDelegate {
  CartAppBarDelegate({required this.height});

  final double height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return CartAppBar();
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
