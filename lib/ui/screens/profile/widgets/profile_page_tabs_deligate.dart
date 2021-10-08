import 'dart:math';

import 'package:elf_play/business_logic/blocs/profile_page/profile_page_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              color: AppColors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildProfileTab(
                    number: "${state.profilePageData.numberOfBoughtItems}",
                    title: "purchases",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterPaths.libraryRoute,
                        arguments: ScreenArguments(
                          args: {
                            AppValues.isLibraryForOffline: false,
                            AppValues.isLibraryForProfile: true,
                            AppValues.profileListTypes:
                                ProfileListTypes.PURCHASED_SONGS,
                          },
                        ),
                      );
                    },
                  ),
                  buildProfileTab(
                    number: "${state.profilePageData.numberOfUserPlaylists}",
                    title: "playlists",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterPaths.libraryRoute,
                        arguments: ScreenArguments(
                          args: {
                            AppValues.isLibraryForOffline: false,
                            AppValues.isLibraryForProfile: true,
                            AppValues.profileListTypes: ProfileListTypes.OTHER,
                          },
                        ),
                      );
                    },
                  ),
                  buildProfileTab(
                    number: "${(state.profilePageData.numberOfFollowedItems)}",
                    title: "following",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouterPaths.libraryRoute,
                        arguments: ScreenArguments(
                          args: {
                            AppValues.isLibraryForOffline: false,
                            AppValues.isLibraryForProfile: true,
                            AppValues.profileListTypes:
                                ProfileListTypes.FOLLOWED_ARTISTS,
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
              color: AppColors.white,
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
