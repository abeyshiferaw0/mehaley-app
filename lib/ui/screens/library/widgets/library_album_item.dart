import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/menu/album_menu_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
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
      child: AppCard(
        radius: 6.0,
        withShadow: false,
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
                  color: ColorMapper.getBlack(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: AppMargin.margin_16),
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
                child: CachedNetworkImage(
                  width: AppValues.artistAlbumItemSize,
                  height: AppValues.artistAlbumItemSize,
                  fit: BoxFit.cover,
                  imageUrl: album.albumImages[0].imageMediumPath,
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
                      color: ColorMapper.getBlack(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppMargin.margin_4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        L10nUtil.translateLocale(
                            album.artist.artistName, context),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          color: ColorMapper.getTxtGrey(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.padding_4,
                        ),
                        child: Icon(
                          Icons.circle,
                          color: ColorMapper.getTxtGrey(),
                          size: AppIconSizes.icon_size_4,
                        ),
                      ),
                      Text(
                        PagesUtilFunctions.getAlbumYear(album).toString(),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          color: ColorMapper.getTxtGrey(),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppMargin.margin_6),
                  SmallTextPriceWidget(
                    isFree: album.isFree,
                    priceEtb: album.priceEtb,
                    priceUsd: album.priceDollar,
                    discountPercentage: album.discountPercentage,
                    isDiscountAvailable: album.isDiscountAvailable,
                    isPurchased: album.isBought,
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              AppBouncingButton(
                onTap: () {
                  PagesUtilFunctions.showMenuSheet(
                    context: context,
                    child: AlbumMenuWidget(
                      album: album,
                      onViewArtistClicked: () {
                        PagesUtilFunctions.artistItemOnClick(
                          album.artist,
                          context,
                        );
                      },
                      onBuyAlbumClicked: () {
                        PurchaseUtil.albumMenuBuyButtonOnClick(
                          context,
                          album,
                          false,
                        );
                      },
                    ),
                  );
                },
                child: Icon(
                  FlutterRemix.more_2_fill,
                  color: ColorMapper.getDarkGrey(),
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
