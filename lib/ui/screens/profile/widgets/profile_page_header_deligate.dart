import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/common/menu/profile_menu_widget.dart';
import 'package:mehaley/ui/common/user_profile_pic.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ProfilePageHeaderDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onBackPress;
  final Color dominantColor;

  ProfilePageHeaderDelegate({
    required this.dominantColor,
    required this.onBackPress,
  });

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return ProfilePageHeader(
      shrinkPercentage: shrinkPercentage,
      dominantColor: dominantColor,
      onBackPress: onBackPress,
    );
  }

  @override
  double get maxExtent => 380;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ProfilePageHeader extends StatefulWidget {
  const ProfilePageHeader({
    Key? key,
    required this.dominantColor,
    required this.onBackPress,
    required this.shrinkPercentage,
  }) : super(key: key);

  final VoidCallback onBackPress;
  final Color dominantColor;
  final double shrinkPercentage;

  @override
  State<ProfilePageHeader> createState() => _ProfilePageHeaderState();
}

class _ProfilePageHeaderState extends State<ProfilePageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        gradient: AppGradients().getProfilePageGradient(widget.dominantColor),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAppBar(widget.shrinkPercentage, context),
            buildProfileInfo(widget.shrinkPercentage, context)
          ],
        ),
      ),
    );
  }

  Transform buildProfileInfo(double shrinkPercentage, context) {
    return Transform.translate(
      offset: Offset(0, 1 - (shrinkPercentage * 150)),
      child: Transform.scale(
        scale: 1 - shrinkPercentage,
        child: Opacity(
          opacity: 1 - shrinkPercentage,
          child: Container(
            height: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: AppValues.profilePagePicSize,
                  width: AppValues.profilePagePicSize,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppValues.profilePagePicSize),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.white.withOpacity(0.1),
                        spreadRadius: 6,
                        blurRadius: 12,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                  child: UserProfilePic(
                    fontSize: AppFontSizes.font_size_16.sp,
                    size: AppValues.profilePagePicSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.padding_16,
                  ),
                  child: BlocBuilder<AppUserWidgetsCubit, AppUser>(
                    builder: (context, state) {
                      return Text(
                        AuthUtil.getUserName(state),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      );
                    },
                  ),
                ),
                AppBouncingButton(
                  onTap: () {
                    PagesUtilFunctions.openEditProfilePage(
                      context,
                      (AppUser appUser) {
                        ///UPDATE USER LOCALLY
                        BlocProvider.of<AppUserWidgetsCubit>(context)
                            .updateAppUser(appUser);

                        ///CHANGE DOMINANT COLOR
                        BlocProvider.of<PagesDominantColorBloc>(context).add(
                          UserProfilePageDominantColorChanged(
                            dominantColor: AuthUtil.getDominantColor(
                                BlocProvider.of<AppUserWidgetsCubit>(context)
                                    .state),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.padding_4,
                      horizontal: AppPadding.padding_16,
                    ),
                    child: Text(
                      AppLocale.of().editProfile.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_8.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack buildAppBar(double shrinkPercentage, mContext) {
    return Stack(
      children: [
        Opacity(
          opacity: shrinkPercentage,
          child: Container(
            height: 80,
            color: widget.dominantColor,
          ),
        ),
        Container(
          height: 80,
          child: SafeArea(
            child: Stack(
              //  crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      widget.onBackPress();
                    },
                    icon: Icon(
                      PhosphorIcons.caret_left_light,
                      color: AppColors.black,
                      size: AppIconSizes.icon_size_24,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: shrinkPercentage,
                    child: BlocBuilder<AppUserWidgetsCubit, AppUser>(
                      builder: (context, state) {
                        return Text(
                          AuthUtil.getUserName(state),
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.padding_4),
                    child: AppBouncingButton(
                      onTap: () {
                        PagesUtilFunctions.showMenuSheet(
                          context: mContext,
                          child: ProfileMenuWidget(
                            onUpdateSuccess: (AppUser appUser) {
                              ///UPDATE USER LOCALLY
                              BlocProvider.of<AppUserWidgetsCubit>(context)
                                  .updateAppUser(appUser);

                              ///CHANGE DOMINANT COLOR
                              BlocProvider.of<PagesDominantColorBloc>(context)
                                  .add(
                                UserProfilePageDominantColorChanged(
                                  dominantColor: AuthUtil.getDominantColor(
                                      BlocProvider.of<AppUserWidgetsCubit>(
                                              context)
                                          .state),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: Icon(
                        PhosphorIcons.dots_three_vertical,
                        color: AppColors.black,
                        size: AppIconSizes.icon_size_24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
