import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:sizer/sizer.dart';

import 'group_song_item_play_icon.dart';

class ItemRecentlyPlayed extends StatelessWidget {
  final double width;
  final double height;
  final String imgUrl;
  final String title;
  final double priceEtb;
  final IapProduct priceUsd;
  final bool isDiscountAvailable;
  final bool isBought;
  final double discountPercentage;
  final bool isFree;
  final VoidCallback onTap;

  ItemRecentlyPlayed({
    required this.width,
    required this.height,
    required this.imgUrl,
    required this.title,
    required this.priceEtb,
    required this.priceUsd,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.isFree,
    required this.onTap,
    required this.isBought,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.only(top: AppMargin.margin_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              radius: 4.0,
              withShadow: false,
              child: CachedNetworkImage(
                width: width,
                height: height,
                fit: BoxFit.cover,
                imageUrl: imgUrl,
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
                    AppIconWidget(),

                    ///PLAY ICON IF SONG ITEM
                    GroupSongItemPlayIcon(
                      groupType: GroupType.SONG,
                    )
                  ],
                ),
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) =>
                    buildItemsImagePlaceHolder(),
              ),
            ),
            SizedBox(height: AppMargin.margin_6),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorMapper.getBlack(),
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            SmallTextPriceWidget(
              priceEtb: priceEtb,
              priceUsd: priceUsd,
              isDiscountAvailable: isDiscountAvailable,
              discountPercentage: discountPercentage,
              isFree: isFree,
              isPurchased: isBought,
            )
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
