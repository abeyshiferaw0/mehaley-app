import 'dart:math';

import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/cart/widgets/cart_horizontal_item.dart';
import 'package:elf_play/ui/screens/cart/widgets/cart_item.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with RouteAware {
  void didChangeDependencies() {
    super.didChangeDependencies();
    //SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    print("routeObserver didPopNext HOME");
    BlocProvider.of<BottomBarCubit>(context).changeScreen(
      BottomBarPages.CART,
    );
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    //CHANGE BOTTOM BAR TO CART PAGE
    BlocProvider.of<BottomBarCubit>(context).changeScreen(
      BottomBarPages.CART,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            //SEARCH PAGE HEADER
            SliverPersistentHeader(
              floating: true,
              pinned: false,
              delegate: CartHeaderDelegate(height: 60),
            ),
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: ClearAndCheckDelegate(),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppMargin.margin_16)),
            SliverToBoxAdapter(
              child: Text(
                "Cart Summery",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppMargin.margin_16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.padding_16,
                  right: AppPadding.padding_16,
                ),
                child: Divider(
                  height: 1,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppMargin.margin_16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppMargin.margin_16,
                  bottom: AppMargin.margin_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Albums",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: 'subTitle',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: 'subTitle',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: 'subTitle',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: 'subTitle',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: 'subTitle',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppMargin.margin_16,
                  top: AppMargin.margin_16,
                  bottom: AppMargin.margin_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Playlists",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: AppMargin.margin_16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: '34 tracks',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: '34 tracks',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: '34 tracks',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: '34 tracks',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                          CartHorizontalItem(
                            price: 4.05,
                            width: 100,
                            imageUrl: '',
                            title: 'title',
                            subTitle: '34 tracks',
                          ),
                          SizedBox(
                            width: AppMargin.margin_16,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppMargin.margin_16,
                  top: AppMargin.margin_16,
                ),
                child: Text(
                  "Mezmurs",
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightGrey,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
                vertical: AppPadding.padding_8,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        CartItem(
                          itemKey: Key("asd"),
                          item: "item",
                          title: "title",
                          subTitle: "subTitle",
                          imagePath: "imagePath",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          child: Divider(
                            height: 1,
                            color: AppColors.darkGreen.withOpacity(0.3),
                          ),
                        )
                      ],
                    );
                  },
                  childCount: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartHeaderDelegate extends SliverPersistentHeaderDelegate {
  CartHeaderDelegate({required this.height});

  final double height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_16,
        horizontal: AppPadding.padding_16,
      ),
      color: AppColors.darkGrey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Elf Cart",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          Expanded(child: SizedBox()),
          Text(
            "Total",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Text(
            "300 ETB",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ClearAndCheckDelegate extends SliverPersistentHeaderDelegate {
  ClearAndCheckDelegate();

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    var opacityPercentage = shrinkOffset / 100;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_28,
        horizontal: AppPadding.padding_16,
      ),
      color: ColorUtil.darken(AppColors.green, 0.2).withOpacity(
        opacityPercentage,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.padding_8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.white,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      "CLEAR ALL",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppMargin.margin_32,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.padding_8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      "CHECK OUT",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: ColorUtil.darken(
                          AppColors.darkGreen,
                          opacityPercentage,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
