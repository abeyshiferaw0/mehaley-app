import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorMapper.getWhite(),
      height: 50,
      child: Stack(
        children: [
          buildDivider(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                // Center(
                //   child: buildSearchBtn(),
                // ),
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                Expanded(
                  child: buildTabs(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBouncingButton buildSearchBtn() {
    return AppBouncingButton(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(AppPadding.padding_16),
        child: Icon(
          FlutterRemix.search_line,
          color: ColorMapper.getBlack(),
        ),
      ),
    );
  }

  Align buildDivider() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 3,
        color: ColorMapper.getLightGrey(),
      ),
    );
  }

  TabBar buildTabs(context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelPadding: EdgeInsets.all(0.0),
      unselectedLabelColor: ColorMapper.getGrey(),
      labelStyle: TextStyle(
        fontSize: AppFontSizes.font_size_12.sp,
        fontWeight: FontWeight.bold,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 3.0, color: ColorMapper.getDarkOrange()),
        insets: EdgeInsets.symmetric(horizontal: 0.0),
      ),
      indicatorPadding: EdgeInsets.zero,
      tabs: [
        buildTabItem(AppLocale.of().purchased.toUpperCase()),
        buildTabItem(AppLocale.of().offline.toUpperCase()),
        buildTabItem(AppLocale.of().myPlaylists.toUpperCase()),
        buildTabItem(AppLocale.of().favorites.toUpperCase()),
        buildTabItem(AppLocale.of().following.toUpperCase()),
      ],
    );
  }

  buildTabItem(String text) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: AppMargin.margin_8),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
