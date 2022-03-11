import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/ui/common/dialog/dialog_delete_user_playlist.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';
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
        color: ColorMapper.getWhite(),
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
            SizedBox(
              height: AppMargin.margin_16,
            ),
            buildMenuHeader(),
            SizedBox(
              height: AppMargin.margin_8,
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
                  //   iconColor: ColorMapper.getGrey().withOpacity(0.6),
                  //   icon: FlutterRemix.plus_circle_light,
                  //   title: AppLocale.of().addMezmurs,
                  //   onTap: () {},
                  // ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: ColorMapper.getGrey().withOpacity(0.6),
                    icon: FlutterRemix.pencil_line,
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
                    iconColor: ColorMapper.getGrey().withOpacity(0.6),
                    icon: FlutterRemix.close_line,
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
                  //   iconColor: ColorMapper.getGrey().withOpacity(0.6),
                  //   icon: FlutterRemix.search_line,
                  //   title: AppLocale.of().findInPlaylist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: ColorMapper.getGrey().withOpacity(0.6),
                  //   icon: FlutterRemix.sort_asc_line,
                  //   title: AppLocale.of().sortPlaylist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: ColorMapper.getGrey().withOpacity(0.6),
                  //   icon: FlutterRemix.share_line,
                  //   title: AppLocale.of().sharePlaylist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: ColorMapper.getGrey().withOpacity(0.6),
                  //   icon: c.smartphone_line,
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
      child: Row(
        children: [
          SizedBox(width: AppMargin.margin_16),
          AppCard(
            withShadow: false,
            radius: 6.0,
            child: Container(
              color: ColorMapper.getTxtGrey(),
              width: AppValues.menuHeaderImageSize,
              height: AppValues.menuHeaderImageSize,
              child: PagesUtilFunctions.getSongGridImage(myPlaylist),
            ),
          ),
          SizedBox(width: AppMargin.margin_16),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: ColorMapper.getBlack(),
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
                      color: ColorMapper.getTxtGrey(),
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
