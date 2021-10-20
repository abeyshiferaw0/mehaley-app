import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
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
            child: CachedNetworkImage(
              imageUrl:
                  AppApi.baseFileUrl + playlist.playlistImage.imageMediumPath,
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
            maxLines: 1,
            textAlign: TextAlign.center,
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
                  price: playlist.priceEtb,
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
