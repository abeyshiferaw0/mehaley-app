import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
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
              imageUrl:
                  AppApi.baseFileUrl + album.albumImages[0].imageMediumPath,
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
              PagesUtilFunctions.albumTitle(album),
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            PagesUtilFunctions.getItemPrice(
              isDiscountAvailable: album.isDiscountAvailable,
              discountPercentage: album.discountPercentage,
              isFree: album.isFree,
              price: album.priceEtb,
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
