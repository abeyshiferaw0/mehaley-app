import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ItemArtistFeaturedPlaylist extends StatelessWidget {
  final Playlist playlist;

  ItemArtistFeaturedPlaylist({
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PagesUtilFunctions.playlistItemOnClick(playlist, context);
      },
      child: Container(
        width: AppValues.featuringArtistItemImageSize,
        child: Padding(
          padding: EdgeInsets.only(top: AppPadding.padding_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                radius: 4.0,
                child: CachedNetworkImage(
                  width: AppValues.featuringArtistItemImageSize,
                  height: AppValues.featuringArtistItemImageSize,
                  imageUrl: playlist.playlistImage.imageMediumPath,
                  imageBuilder: (context, imageProvider) => Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      AppIconWidget()
                    ],
                  ),
                  placeholder: (context, url) => buildItemsImagePlaceHolder(),
                  errorWidget: (context, url, error) =>
                      buildItemsImagePlaceHolder(),
                ),
              ),
              SizedBox(height: AppMargin.margin_8),
              Text(
                L10nUtil.translateLocale(playlist.playlistNameText, context),
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ColorMapper.getBlack(),
                  fontWeight: FontWeight.w500,
                  fontSize: AppFontSizes.font_size_10.sp,
                ),
              ),
              playlist.isFree
                  ? SizedBox()
                  : PagesUtilFunctions.getItemPrice(
                      discountPercentage: playlist.discountPercentage,
                      isFree: playlist.isFree,
                      priceEtb: playlist.priceEtb,
                      priceUsd: playlist.priceDollar,
                      isDiscountAvailable: playlist.isDiscountAvailable,
                      isPurchased: playlist.isBought,
                    )
            ],
          ),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
  }
}
