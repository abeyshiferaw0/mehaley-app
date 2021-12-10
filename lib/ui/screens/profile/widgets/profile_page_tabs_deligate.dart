import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/profile_page/profile_page_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class ProfilePageTabsDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  ProfilePageTabsDelegate({required this.height});

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Container(
      height: height,
      child: BlocBuilder<ProfilePageBloc, ProfilePageState>(
        builder: (context, state) {
          if (state is ProfilePageLoadedState) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppMargin.margin_32,
                vertical: AppPadding.padding_4,
              ),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildProfileTab(
                    number: '${state.profilePageData.numberOfBoughtItems}',
                    title: AppLocale.of().purchases,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterPaths.libraryRoute,
                        arguments: ScreenArguments(
                          args: {
                            AppValues.isLibraryForOffline: false,
                            AppValues.isLibraryForOtherPage: true,
                            AppValues.libraryFromOtherPageTypes:
                                LibraryFromOtherPageTypes.PURCHASED_SONGS,
                          },
                        ),
                      );
                    },
                  ),
                  buildProfileTab(
                    number: '${state.profilePageData.numberOfUserPlaylists}',
                    title: AppLocale.of().playlists,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterPaths.libraryRoute,
                        arguments: ScreenArguments(
                          args: {
                            AppValues.isLibraryForOffline: false,
                            AppValues.isLibraryForOtherPage: true,
                            AppValues.libraryFromOtherPageTypes:
                                LibraryFromOtherPageTypes.USER_PLAYLIST,
                          },
                        ),
                      );
                    },
                  ),
                  buildProfileTab(
                    number: '${(state.profilePageData.numberOfFollowedItems)}',
                    title: AppLocale.of().following.toUpperCase(),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterPaths.libraryRoute,
                        arguments: ScreenArguments(
                          args: {
                            AppValues.isLibraryForOffline: false,
                            AppValues.isLibraryForOtherPage: true,
                            AppValues.libraryFromOtherPageTypes:
                                LibraryFromOtherPageTypes.FOLLOWED_ARTISTS,
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  AppBouncingButton buildProfileTab({
    required String number,
    required String title,
    required VoidCallback onTap,
  }) {
    return AppBouncingButton(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              letterSpacing: 0.8,
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
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
