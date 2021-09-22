import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

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
          backgroundColor: AppColors.darkGrey,
          unselectedItemColor: AppColors.grey,
          selectedItemColor: AppColors.white,
          unselectedLabelStyle: TextStyle(
            color: AppColors.grey,
            fontSize: 11,
          ),
          selectedLabelStyle: TextStyle(
            color: AppColors.white,
            fontSize: AppFontSizes.font_size_12,
          ),
          currentIndex: getBottomBarIndex(state),
          onTap: (pos) {
            if (getBottomBarIndex(state) != pos) {
              if (pos == 0) {
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
              } else if (pos == 1) {
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
              } else if (pos == 2) {
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
              } else if (pos == 3) {
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
                icon: PhosphorIcons.house_fill,
                color: AppColors.white,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: PhosphorIcons.house_light,
                color: AppColors.grey,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: PhosphorIcons.magnifying_glass_fill,
                color: AppColors.white,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: PhosphorIcons.magnifying_glass_light,
                color: AppColors.grey,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: PhosphorIcons.stack_fill,
                color: AppColors.white,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: PhosphorIcons.stack_light,
                color: AppColors.grey,
              ),
              label: "Library",
            ),
            BottomNavigationBarItem(
              activeIcon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarActiveIconSize,
                icon: PhosphorIcons.shopping_cart_simple_fill,
                color: AppColors.white,
              ),
              icon: BottomBarIcon(
                bottomSpace: 2,
                size: AppValues.bottomBarIconSize,
                icon: PhosphorIcons.shopping_cart_simple_light,
                color: AppColors.grey,
              ),
              label: "Cart",
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

  BottomBarIcon(
      {required this.icon,
      required this.bottomSpace,
      required this.size,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Icon(icon, color: color, size: size),
    );
  }
}
