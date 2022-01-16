import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ItemPopularAlbum extends StatelessWidget {
  final Album album;

  ItemPopularAlbum({
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
        width: AppValues.categoryPopularItemsSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: album.albumImages[0].imageMediumPath,
              width: AppValues.categoryPopularItemsSize,
              height: AppValues.categoryPopularItemsSize,
              imageBuilder: (context, imageProvider) => Stack(
                children: [
                  Container(
                    width: AppValues.categoryPopularItemsSize,
                    height: AppValues.categoryPopularItemsSize,
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
            SizedBox(height: AppMargin.margin_6),
            Text(
              PagesUtilFunctions.albumTitle(album, context),
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            PagesUtilFunctions.getItemPrice(
              isDiscountAvailable: album.isDiscountAvailable,
              discountPercentage: album.discountPercentage,
              isFree: album.isFree,
              priceEtb: album.priceEtb,
              priceUsd: album.priceDollar,
              isPurchased: album.isBought,
            )
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ALBUM);
  }
}
