import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
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
              CachedNetworkImage(
                width: AppValues.featuringArtistItemImageSize,
                height: AppValues.featuringArtistItemImageSize,
                imageUrl:
                    AppApi.baseUrl + playlist.playlistImage.imageMediumPath,
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
              SizedBox(height: AppMargin.margin_8),
              Text(
                L10nUtil.translateLocale(playlist.playlistNameText, context),
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
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
