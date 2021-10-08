import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/common/small_text_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemRecentlyPlayed extends StatelessWidget {
  final double width;
  final double height;
  final String imgUrl;
  final String title;
  final double price;
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
    required this.price,
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
            CachedNetworkImage(
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
                  AppIconWidget()
                ],
              ),
              placeholder: (context, url) => buildItemsImagePlaceHolder(),
              errorWidget: (context, url, error) =>
                  buildItemsImagePlaceHolder(),
            ),
            SizedBox(height: AppMargin.margin_6),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            SmallTextPriceWidget(
              price: price,
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
