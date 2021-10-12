import 'package:elf_play/data/models/cart/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_app_bar.dart';

class CartAppBarDelegate extends SliverPersistentHeaderDelegate {
  CartAppBarDelegate({required this.cart, required this.height});

  final Cart cart;

  final double height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return CartAppBar(
      hasPrice: true,
      cart: cart,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
