import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cart_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_home_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_library_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_search_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/ui/common/user_image_sm.dart';

class BottomBar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const BottomBar({required this.navigatorKey});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, BottomBarPages>(
      builder: (context, state) {
        return BottomNavigationBar(
          enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          unselectedItemColor: AppColors.grey,
          selectedItemColor: AppColors.darkOrange,
          unselectedLabelStyle: TextStyle(
            color: AppColors.grey,
            fontSize: 11,
          ),
          selectedLabelStyle: TextStyle(
            color: AppColors.darkOrange,
            fontSize: AppFontSizes.font_size_12,
          ),
          currentIndex: getBottomBarIndex(state),
          onTap: (pos) {
            if (pos == 0) {
              if (!BlocProvider.of<BottomBarHomeCubit>(context).state) {
                BlocProvider.of<BottomBarCubit>(context).changeScreen(
                  BottomBarPages.HOME,
                );

                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  AppRouterPaths.homeRoute,
                  ModalRoute.withName(
                    AppRouterPaths.homeRoute,
                  ),
                );

                // widget.navigatorKey.currentState!.pushNamed(
                //   AppRouterPaths.homeRoute,
                // );
              }
            } else if (pos == 1) {
              if (!BlocProvider.of<BottomBarSearchCubit>(context).state) {
                BlocProvider.of<BottomBarCubit>(context).changeScreen(
                  BottomBarPages.SEARCH,
                );

                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  AppRouterPaths.searchRoute,
                  ModalRoute.withName(
                    AppRouterPaths.homeRoute,
                  ),
                );

                // widget.navigatorKey.currentState!.pushNamed(
                //   AppRouterPaths.searchRoute,
                // );
              }
            } else if (pos == 2) {
              if (!BlocProvider.of<BottomBarLibraryCubit>(context).state) {
                BlocProvider.of<BottomBarCubit>(context).changeScreen(
                  BottomBarPages.LIBRARY,
                );

                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  AppRouterPaths.libraryRoute,
                  ModalRoute.withName(
                    AppRouterPaths.homeRoute,
                  ),
                  arguments: ScreenArguments(
                    args: {AppValues.isLibraryForOffline: false},
                  ),
                );

                // widget.navigatorKey.currentState!.pushNamed(
                //   AppRouterPaths.libraryRoute,
                // );
              }
            } else if (pos == 3) {
              if (!BlocProvider.of<BottomBarCartCubit>(context).state) {
                BlocProvider.of<BottomBarCubit>(context).changeScreen(
                  BottomBarPages.CART,
                );

                widget.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  AppRouterPaths.cartRoute,
                  ModalRoute.withName(
                    AppRouterPaths.homeRoute,
                  ),
                );

                // widget.navigatorKey.currentState!.pushNamed(
                //   AppRouterPaths.cartRoute,
                // );
              }
            }
          },
          items: [
            BottomNavigationBarItem(
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: FlutterRemix.home_line,
                color: AppColors.orange,
                isForLibrary: false,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: FlutterRemix.home_line,
                color: AppColors.grey,
                isForLibrary: false,
              ),
              label: AppLocale.of().home,
              tooltip: AppLocale.of().home,
            ),
            BottomNavigationBarItem(
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: FlutterRemix.search_line,
                color: AppColors.orange,
                isForLibrary: false,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: FlutterRemix.search_line,
                color: AppColors.grey,
                isForLibrary: false,
              ),
              label: AppLocale.of().search,
              tooltip: AppLocale.of().search,
            ),
            BottomNavigationBarItem(
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: FlutterRemix.stack_line,
                color: AppColors.orange,
                isForLibrary: false,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: FlutterRemix.stack_line,
                color: AppColors.grey,
                isForLibrary: false,
              ),
              label: AppLocale.of().myLibrary,
              tooltip: AppLocale.of().myLibrary,
            ),
            BottomNavigationBarItem(
              tooltip: AppLocale.of().cart,
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: FlutterRemix.shopping_cart_2_line,
                color: AppColors.orange,
                isForLibrary: false,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: FlutterRemix.shopping_cart_2_line,
                color: AppColors.grey,
                isForLibrary: false,
              ),
              label: AppLocale.of().cart,
            ),
          ],
        );
      },
    );
  }

  int getBottomBarIndex(BottomBarPages state) {
    if (state == BottomBarPages.HOME) {
      return 0;
    } else if (state == BottomBarPages.SEARCH) {
      return 1;
    } else if (state == BottomBarPages.LIBRARY) {
      return 2;
    } else if (state == BottomBarPages.CART) {
      return 3;
    }
    return 0;
  }
}

class BottomBarIcon extends StatelessWidget {
  final IconData icon;
  final double bottomSpace;
  final double size;
  final Color color;
  final bool isForLibrary;

  BottomBarIcon({
    required this.icon,
    required this.bottomSpace,
    required this.size,
    required this.color,
    required this.isForLibrary,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserWidgetsCubit, AppUser>(
      builder: (context, state) {
        return Container(child: getProfilePic(state, context));
      },
    );
  }

  Widget getProfilePic(AppUser appUser, context) {
    if (isForLibrary) {
      if (appUser.profileImageId != null) {
        return UserImageSm(
          size: size,
          appUser: appUser,
          appUserImageType: AppUserImageType.PROFILE_IMAGE,
          borderColor: color,
          hasBorder: true,
          fontSize: AppFontSizes.font_size_8,
          letter: AppLocale.of().libraryShort,
        );
      } else if (appUser.socialProfileImgUrl != null) {
        return UserImageSm(
          size: size,
          appUser: appUser,
          appUserImageType: AppUserImageType.SOCIAL_IMAGE,
          borderColor: color,
          hasBorder: true,
          fontSize: AppFontSizes.font_size_8,
          letter: AppLocale.of().libraryShort,
        );
      } else {
        return UserImageSm(
          size: size,
          appUser: appUser,
          appUserImageType: AppUserImageType.NONE,
          borderColor: color,
          hasBorder: true,
          fontSize: AppFontSizes.font_size_8,
          letter: AppLocale.of().libraryShort,
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.all(0.0),
        child: Icon(icon, color: color, size: size),
      );
    }
  }
}
