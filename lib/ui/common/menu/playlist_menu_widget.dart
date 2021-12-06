import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/menu/menu_items/playlist_cart_menu_item.dart';
import 'package:mehaley/ui/common/menu/menu_items/playlist_follow_menu_item.dart';
import 'package:sizer/sizer.dart';

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
            buildMenuHeader(context),
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
                          icon: FlutterRemix.money_dollar_circle_line,
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
                    icon: FlutterRemix.search_line,
                    title: AppLocale.of().findInPlaylist,
                    onTap: () {},
                  ),
                  // MenuItem(
                  //   isDisabled: false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: FlutterRemix.sort_asc,
                  //   title: AppLocale.of().sortPlaylist,
                  //   onTap: () {},
                  // ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: FlutterRemix.share_line,
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
      padding: EdgeInsets.all(AppPadding.padding_20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppCard(
            radius: 6.0,
            withShadow: false,
            child: CachedNetworkImage(
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
          ),
          SizedBox(width: AppMargin.margin_16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppMargin.margin_4),
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
              SizedBox(height: AppMargin.margin_4),
              Text(
                AppLocale.of().byElfPlay.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.txtGrey,
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w400,
                ),
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
