import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class SearchPersistentSliverHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return AppBouncingButton(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouterPaths.searchResultRoute,
          arguments: ScreenArguments(args: {'isVoiceTyping': false}),
        );
      },
      child: Container(
        color: AppColors.black,
        height: AppValues.searchPersistentSliverHeaderHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.symmetric(vertical: AppPadding.padding_12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppMargin.margin_12,
                    ),
                    Icon(
                      PhosphorIcons.magnifying_glass_light,
                      color: AppColors.darkGrey,
                      size: AppIconSizes.icon_size_24,
                    ),
                    SizedBox(
                      width: AppMargin.margin_12,
                    ),
                    Text(
                      "Search Mezmurs, Playlists, Artists",
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouterPaths.searchResultRoute,
                  arguments: ScreenArguments(args: {'isVoiceTyping': true}),
                );
              },
              icon: Icon(
                PhosphorIcons.microphone_thin,
                color: AppColors.lightGrey,
                size: AppIconSizes.icon_size_28,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => AppValues.searchPersistentSliverHeaderHeight;

  @override
  double get minExtent => AppValues.searchPersistentSliverHeaderHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
