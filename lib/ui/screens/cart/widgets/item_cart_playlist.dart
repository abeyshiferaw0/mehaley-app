import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/screens/cart/widgets/remove_from_cart_button.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class CartPlaylistItem extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onRemoveFromCart;

  CartPlaylistItem({
    required this.playlist,
    required this.onRemoveFromCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PagesUtilFunctions.playlistItemOnClick(playlist, context);
      },
      child: Container(
        width: AppValues.cartItemsSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: AppApi.baseUrl + playlist.playlistImage.imageMediumPath,
              width: AppValues.cartItemsSize,
              height: AppValues.cartItemsSize,
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
              L10nUtil.translateLocale(playlist.playlistNameText, context),
              maxLines: 2,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.txtGrey,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            playlist.isFree
                ? SizedBox()
                : PagesUtilFunctions.getItemPrice(
                    isDiscountAvailable: playlist.isDiscountAvailable,
                    discountPercentage: playlist.discountPercentage,
                    isFree: playlist.isFree,
                    priceEtb: playlist.priceEtb,
                    priceUsd: playlist.priceDollar,
                    isPurchased: playlist.isBought,
                  ),
            RemoveFromCartButton(
              onRemoveFromCart: () {
                onRemoveFromCart();
              },
              isWithText: true,
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
  }
}
