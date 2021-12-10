import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/menu/menu_items/album_favorite_menu_item.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';
import '../player_items_placeholder.dart';
import '../small_text_price_widget.dart';
import 'menu_items/album_cart_menu_item.dart';
import 'menu_items/menu_item.dart';

class AlbumMenuWidget extends StatelessWidget {
  AlbumMenuWidget({
    Key? key,
    required this.album,
    required this.onViewArtistClicked,
    required this.onBuyAlbumClicked,
  }) : super(key: key);

  final Album album;
  final VoidCallback onViewArtistClicked;
  final VoidCallback onBuyAlbumClicked;

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
                  (!album.isBought && !album.isFree)
                      ? MenuItem(
                          isDisabled: false,
                          hasTopMargin: false,
                          iconColor: AppColors.grey.withOpacity(0.6),
                          icon: FlutterRemix.money_dollar_circle_line,
                          title: AppLocale.of().buyAlbum,
                          onTap: () {
                            Navigator.pop(context);
                            onBuyAlbumClicked();
                          },
                        )
                      : SizedBox(),
                  AlbumCartMenuItem(album: album),
                  AlbumFavoriteMenuItem(
                    hasTopMargin: true,
                    isDisabled: false,
                    isLiked: album.isLiked,
                    albumId: album.albumId,
                    unlikedColor: AppColors.grey.withOpacity(0.6),
                    likedColor: AppColors.darkOrange,
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: FlutterRemix.user_voice_line,
                    title: AppLocale.of().viewArtist,
                    onTap: () {
                      Navigator.pop(context);
                      onViewArtistClicked();
                    },
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: FlutterRemix.share_line,
                    title: AppLocale.of().shareAlbum,
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
            withShadow: false,
            radius: 6.0,
            child: CachedNetworkImage(
              height: AppValues.menuHeaderImageSize,
              width: AppValues.menuHeaderImageSize,
              imageUrl: AppApi.baseUrl + album.albumImages[0].imageMediumPath,
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
                L10nUtil.translateLocale(album.albumTitle, context),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppMargin.margin_2),
              SmallTextPriceWidget(
                priceEtb: album.priceEtb,
                priceUsd: album.priceDollar,
                isFree: album.isFree,
                discountPercentage: album.discountPercentage,
                isDiscountAvailable: album.isDiscountAvailable,
                isPurchased: album.isBought,
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
