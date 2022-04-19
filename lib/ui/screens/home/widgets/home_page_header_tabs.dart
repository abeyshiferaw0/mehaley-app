import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:sizer/sizer.dart';

class HomePageHeaderTabs extends StatelessWidget {
  const HomePageHeaderTabs(
      {Key? key, required this.tabController, required this.shrinkPercentage})
      : super(key: key);

  final TabController tabController;
  final double shrinkPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.homePageHeaderTabsHeight,
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        boxShadow: [
          BoxShadow(
            color: AppColors.completelyBlack.withOpacity(0.2),
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_12,
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        padding: EdgeInsets.only(left: AppPadding.padding_16),
        labelPadding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
        indicatorPadding: EdgeInsets.zero,

        //  indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorMapper.getOrange1(), ColorMapper.getDarkOrange()],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        // indicator: UnderlineTabIndicator(
        //   borderSide: BorderSide(
        //     width: 3.0,
        //     color: ColorMapper.getDarkOrange(),
        //   ),
        //   insets: EdgeInsets.symmetric(horizontal: 0.0),
        // ),
        unselectedLabelColor: ColorMapper.getGrey(),
        labelColor: ColorMapper.getWhite(),
        labelStyle: TextStyle(
          fontSize: (AppFontSizes.font_size_10).sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        tabs: [
          buildTabItem(
            AppLocale.of().explore.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allSongs.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allAlbums.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allArtists.toUpperCase(),
          ),
          buildTabItem(
            AppLocale.of().allPlaylists.toUpperCase(),
          ),
        ],
      ),
    );
  }

  buildTabItem(String text) {
    return Center(
      child: Text(
        text,
      ),
    );
  }
}
