import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/screens/cart/widgets/remove_from_cart_button.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
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
              errorWidget: (context, url, error) => buildItemsImagePlaceHolder(),
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
                    price: playlist.priceEtb,
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
