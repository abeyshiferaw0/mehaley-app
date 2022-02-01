import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class LibraryPlaylistItem extends StatelessWidget {
  final Playlist playlist;

  LibraryPlaylistItem({
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        PagesUtilFunctions.playlistItemOnClick(playlist, context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AppCard(
              withShadow: false,
              radius: 4.0,
              child: CachedNetworkImage(
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
          ),
          SizedBox(height: AppMargin.margin_8),
          Text(
            L10nUtil.translateLocale(playlist.playlistNameText, context),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.black,
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
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
  }
}
