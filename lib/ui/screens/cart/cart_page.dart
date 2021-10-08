import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_page_bloc.dart';
import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/cart/widgets/cart_clear_and_check_delegate.dart';
import 'package:elf_play/ui/screens/cart/widgets/cart_header_delegate.dart';
import 'package:elf_play/ui/screens/cart/widgets/cart_horizontal_item.dart';
import 'package:elf_play/ui/screens/cart/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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

    ///LOAD CART PAGE
    BlocProvider.of<CartPageBloc>(context).add(
      LoadCartPageEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        slivers: [
          //SEARCH PAGE HEADER
          SliverPersistentHeader(
            floating: true,
            pinned: false,
            delegate: CartHeaderDelegate(height: 90),
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
    );
  }
}
