import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
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
        height: AppValues.searchPersistentSliverHeaderHeight,
        color: AppColors.pagesBgColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: AppPadding.padding_12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppMargin.margin_12,
                    ),
                    Icon(
                      FlutterRemix.search_line,
                      color: AppColors.txtGrey,
                      size: AppIconSizes.icon_size_24,
                    ),
                    SizedBox(
                      width: AppMargin.margin_12,
                    ),
                    Text(
                      AppLocale.of().searchHint,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.txtGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     Navigator.pushNamed(
            //       context,
            //       AppRouterPaths.searchResultRoute,
            //       arguments: ScreenArguments(args: {'isVoiceTyping': true}),
            //     );
            //   },
            //   icon: Icon(
            //     FlutterRemix.mic_line,
            //     color: AppColors.lightGrey,
            //     size: AppIconSizes.icon_size_28,
            //   ),
            // )
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
