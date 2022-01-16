import 'package:flutter/material.dart';

class SubscriptionSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  SubscriptionSliverHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
