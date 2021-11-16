import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/ui/common/dialog/dialog_delete_user_playlist.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';
import '../player_items_placeholder.dart';
import 'menu_items/menu_item.dart';

class UserPlaylistMenuWidget extends StatelessWidget {
  UserPlaylistMenuWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.playlistId,
    required this.isFollowed,
    required this.myPlaylist,
    required this.onUpdateSuccess,
    required this.onPlaylistDelete,
  }) : super(key: key);

  final int playlistId;
  final MyPlaylist myPlaylist;
  final bool isFollowed;
  final String title;
  final String imageUrl;
  final double price;
  final bool isFree;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final Function(MyPlaylist myPlaylist) onUpdateSuccess;
  final Function(MyPlaylist myPlaylist) onPlaylistDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppValues.menuBottomSheetRadius),
          topRight: Radius.circular(AppValues.menuBottomSheetRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: AppMargin.margin_48,
              ),
              child: AppBouncingButton(
                child: Icon(
                  PhosphorIcons.caret_circle_down_light,
                  color: AppColors.darkGrey,
                  size: AppIconSizes.icon_size_32,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: ScreenUtil(context: context).getScreenHeight() * 0.2,
            ),
            buildMenuHeader(),
            SizedBox(
              height: AppMargin.margin_32,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppMargin.margin_16,
              ),
              child: Column(
                children: [
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: false,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.plus_circle_light,
                  //   title: AppLocale.of().addMezmurs,
                  //   onTap: () {},
                  // ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.pencil_simple_light,
                    title: AppLocale.of().editPlaylist,
                    onTap: () {
                      PagesUtilFunctions.openEditPlaylistPage(
                        context,
                        myPlaylist,
                        onUpdateSuccess,
                      );
                    },
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.x_light,
                    title: AppLocale.of().deletePlaylist,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Center(
                            child: DialogDeleteUserPlaylist(
                              mainButtonText:
                                  AppLocale.of().delete.toUpperCase(),
                              cancelButtonText:
                                  AppLocale.of().cancel.toUpperCase(),
                              titleText:
                                  AppLocale.of().deletePlaylistPermanently,
                              onDelete: () {
                                onPlaylistDelete(myPlaylist);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.magnifying_glass_light,
                  //   title: AppLocale.of().findInPlaylist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.sort_ascending_light,
                  //   title: AppLocale.of().sortPlaylist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.share_network_light,
                  //   title: AppLocale.of().sharePlaylist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.device_mobile_camera_light,
                  //   title: AppLocale.of().addToHomeScreen,
                  //   onTap: () {},
                  // ),
                  SizedBox(height: AppMargin.margin_20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildMenuHeader() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: AppColors.txtGrey,
            width: AppValues.menuHeaderImageSize,
            height: AppValues.menuHeaderImageSize,
            child: PagesUtilFunctions.getSongGridImage(myPlaylist),
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppMargin.margin_2),
          BlocBuilder<AppUserWidgetsCubit, AppUser>(
            builder: (context, state) {
              return Text(
                AppLocale.of()
                    .byUserName(userName: AuthUtil.getUserName(state))
                    .toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.txtGrey,
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
