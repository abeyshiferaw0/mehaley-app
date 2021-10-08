import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients().getMenuGradient(),
        ),
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
                  color: AppColors.lightGrey,
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
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: false,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.plus_circle_light,
                    title: "Add mezmurs",
                    onTap: () {},
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.pencil_simple_light,
                    title: "Edit playlist",
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
                    title: "Delete playlist",
                    onTap: () {},
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.magnifying_glass_light,
                    title: "Find in playlist",
                    onTap: () {},
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.sort_ascending_light,
                    title: "Sort playlist",
                    onTap: () {},
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.share_network_light,
                    title: "Share playlist",
                    onTap: () {},
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.device_mobile_camera_light,
                    title: "Add to home screen",
                    onTap: () {},
                  ),
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
              color: AppColors.white,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppMargin.margin_2),
          BlocBuilder<AppUserWidgetsCubit, AppUser>(
            builder: (context, state) {
              return Text(
                "BY ${AuthUtil.getUserName(state)}".toUpperCase(),
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
