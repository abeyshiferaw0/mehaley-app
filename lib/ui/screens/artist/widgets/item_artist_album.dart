import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ArtistAlbumItem extends StatelessWidget {
  final int position;
  final Album album;

  const ArtistAlbumItem({
    required this.position,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PagesUtilFunctions.albumItemOnClick(album, context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppMargin.margin_20,
          vertical: AppMargin.margin_4,
        ),
        child: Row(
          children: [
            // Text(
            //   (position + 1).toString(),
            //   style: TextStyle(
            //     fontSize: AppFontSizes.font_size_8.sp,
            //     color: AppColors.white,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // SizedBox(width: AppMargin.margin_16),
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              child: CachedNetworkImage(
                width: AppValues.artistAlbumItemSize,
                height: AppValues.artistAlbumItemSize,
                fit: BoxFit.cover,
                imageUrl:  album.albumImages[0].imageSmallPath,
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
            SizedBox(width: AppMargin.margin_8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nUtil.translateLocale(album.albumTitle, context),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppMargin.margin_4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      PagesUtilFunctions.getAlbumYear(album),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.txtGrey,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
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
                      AppLocale.of().album,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.txtGrey,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: AppMargin.margin_4,
                    ),
                    SmallTextPriceWidget(
                      priceEtb: album.priceEtb,
                      priceUsd: album.priceDollar,
                      isFree: album.isFree,
                      isDiscountAvailable: album.isDiscountAvailable,
                      discountPercentage: album.discountPercentage,
                      isPurchased: album.isBought,
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_6),
              ],
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
