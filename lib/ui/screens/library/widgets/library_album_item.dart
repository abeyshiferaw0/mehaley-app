import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/menu/album_menu_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/common/small_text_price_widget.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class LibraryAlbumItem extends StatelessWidget {
  final int position;
  final Album album;

  const LibraryAlbumItem({
    required this.position,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        PagesUtilFunctions.albumItemOnClick(album, context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppMargin.margin_8,
        ),
        child: Row(
          children: [
            Text(
              (position + 1).toString(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: AppMargin.margin_16),
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              child: CachedNetworkImage(
                width: AppValues.artistAlbumItemSize,
                height: AppValues.artistAlbumItemSize,
                fit: BoxFit.cover,
                imageUrl:
                    AppApi.baseFileUrl + album.albumImages[0].imageSmallPath,
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
            SizedBox(width: AppMargin.margin_8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.albumTitle.textAm,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppMargin.margin_4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      album.artist.artistName.textAm,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.txtGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_4,
                      ),
                      child: Icon(
                        Icons.circle,
                        color: AppColors.txtGrey,
                        size: AppIconSizes.icon_size_4,
                      ),
                    ),
                    Text(
                      PagesUtilFunctions.getAlbumYear(album).toString(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.txtGrey,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_6),
                SmallTextPriceWidget(
                  isFree: album.isFree,
                  price: album.priceEtb,
                  discountPercentage: album.discountPercentage,
                  isDiscountAvailable: album.isDiscountAvailable,
                  isPurchased: album.isBought,
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            AppBouncingButton(
              onTap: () {
                PagesUtilFunctions.showMenuDialog(
                  context: context,
                  child: AlbumMenuWidget(
                    albumId: album.albumId,
                    isLiked: album.isLiked,
                    title: album.albumTitle.textAm,
                    imageUrl: AppApi.baseFileUrl +
                        album.albumImages[0].imageMediumPath,
                    price: album.priceEtb,
                    isFree: album.isFree,
                    isDiscountAvailable: album.isDiscountAvailable,
                    discountPercentage: album.discountPercentage,
                    isBought: album.isBought,
                  ),
                );
              },
              child: Icon(
                PhosphorIcons.dots_three_vertical_bold,
                color: AppColors.lightGrey,
                size: AppIconSizes.icon_size_24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
