import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGrey,
      height: 50,
      child: Stack(
        children: [
          buildDivider(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Center(
                  child: buildSearchBtn(),
                ),
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                Expanded(
                  child: buildTabs(),
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
          PhosphorIcons.magnifying_glass_light,
          color: AppColors.white,
        ),
      ),
    );
  }

  Align buildDivider() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 3,
        color: ColorUtil.darken(AppColors.white, 0.7),
      ),
    );
  }

  TabBar buildTabs() {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelPadding: EdgeInsets.all(0.0),
      unselectedLabelColor: AppColors.grey,
      labelStyle: TextStyle(
        fontSize: AppFontSizes.font_size_14.sp,
        fontWeight: FontWeight.bold,
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 3.0, color: AppColors.darkGreen),
        insets: EdgeInsets.symmetric(horizontal: 0.0),
      ),
      indicatorPadding: EdgeInsets.zero,
      tabs: [
        buildTabItem("PURCHASED"),
        buildTabItem("OFFLINE"),
        buildTabItem("PLAYLIST"),
        buildTabItem("FAVORITES"),
        buildTabItem("FOLLOWING"),
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
