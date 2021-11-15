import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/common/menu/menu_items/playlist_cart_menu_item.dart';
import 'package:mehaley/ui/common/menu/menu_items/playlist_follow_menu_item.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';
import '../player_items_placeholder.dart';
import '../small_text_price_widget.dart';
import 'menu_items/menu_item.dart';

class PlaylistMenuWidget extends StatelessWidget {
  PlaylistMenuWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.priceEtb,
    required this.priceUsd,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.playlistId,
    required this.isFollowed,
    required this.isPurchased,
    required this.playlist,
  }) : super(key: key);

  final int playlistId;
  final bool isFollowed;
  final String title;
  final String imageUrl;
  final double priceEtb;
  final double priceUsd;
  final bool isFree;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool isPurchased;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil(context: context).getScreenHeight(),
      decoration: BoxDecoration(
        gradient: AppGradients().getMenuGradient(),
      ),
      child: SingleChildScrollView(
        reverse: true,
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
            buildMenuHeader(context),
            SizedBox(
              height: AppMargin.margin_32,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppMargin.margin_16,
              ),
              child: Column(
                children: [
                  (!playlist.isBought && !playlist.isFree)
                      ? MenuItem(
                          isDisabled: false,
                          hasTopMargin: false,
                          iconColor: AppColors.grey.withOpacity(0.6),
                          icon: PhosphorIcons.currency_circle_dollar_thin,
                          title: AppLocale.of().buyPlaylist,
                          onTap: () {},
                        )
                      : SizedBox(),
                  PlaylistCartMenuItem(
                    playlist: playlist,
                  ),
                  PlaylistFollowMenuItem(
                    playlistId: playlistId,
                    isFollowing: isFollowed,
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.magnifying_glass_light,
                    title: AppLocale.of().findInPlaylist,
                    onTap: () {},
                  ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.sort_ascending_light,
                  //   title: AppLocale.of().sortPlaylist,
                  //   onTap: () {},
                  // ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.share_network_light,
                    title: AppLocale.of().sharePlaylist,
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

  Container buildMenuHeader(context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            height: AppValues.menuHeaderImageSize,
            width: AppValues.menuHeaderImageSize,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => buildImagePlaceHolder(),
            errorWidget: (context, url, error) => buildImagePlaceHolder(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
          isFree
              ? SizedBox()
              : SmallTextPriceWidget(
                  priceEtb: priceEtb,
                  priceUsd: priceUsd,
                  isDiscountAvailable: isDiscountAvailable,
                  isFree: isFree,
                  discountPercentage: discountPercentage,
                  isPurchased: isPurchased,
                ),
          SizedBox(height: AppMargin.margin_2),
          Text(
            AppLocale.of().byElfPlay.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.txtGrey,
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
