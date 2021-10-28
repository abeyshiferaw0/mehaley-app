import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';

import 'item_featured_songs.dart';

class HomeFeaturedSongs extends StatefulWidget {
  const HomeFeaturedSongs({Key? key}) : super(key: key);

  @override
  _HomeFeaturedSongsState createState() => _HomeFeaturedSongsState();
}

class _HomeFeaturedSongsState extends State<HomeFeaturedSongs> {
  late final _currentPageNotifier;
  late PageController _pageController;

  @override
  void initState() {
    _currentPageNotifier = ValueNotifier<int>(0);
    _pageController = PageController(viewportFraction: 0.92);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(),
          SizedBox(
            height: AppMargin.margin_12,
          ),
          buildIndicators(),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          buildFeaturedItemsPager()
        ],
      ),
    );
  }

  Container buildFeaturedItemsPager() {
    return Container(
      height: AppValues.featuredSongsPagerHeight,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          _currentPageNotifier.value = index;
        },
        itemBuilder: (context, index) {
          return FeaturedSongsItem();
        },
      ),
    );
  }

  Padding buildIndicators() {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: CirclePageIndicator(
        itemCount: 5,
        size: AppIconSizes.icon_size_10,
        selectedSize: AppIconSizes.icon_size_10,
        selectedDotColor: AppColors.darkGreen,
        dotColor: ColorUtil.lighten(AppColors.darkGrey, 0.2),
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: Text(
        "Featured Mezmurs",
        style: TextStyle(
          color: Colors.white,
          fontSize: AppFontSizes.font_size_14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
