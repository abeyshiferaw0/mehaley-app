import 'package:flutter/material.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_header_one.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_header_two.dart';

class WalletPageHeadersDelegate extends SliverPersistentHeaderDelegate {
  WalletPageHeadersDelegate(
      {required this.headerOneHeight,
      required this.headerTwoHeight,
      required this.walletPageData});

  final double headerOneHeight;
  final double headerTwoHeight;
  final WalletPageData walletPageData;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
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
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => headerTwoHeight + headerOneHeight;

  @override
  double get minExtent => headerTwoHeight + headerOneHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
