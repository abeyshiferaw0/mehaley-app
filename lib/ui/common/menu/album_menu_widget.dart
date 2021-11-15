import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/menu/menu_items/album_favorite_menu_item.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../app_gradients.dart';
import '../player_items_placeholder.dart';
import '../small_text_price_widget.dart';
import 'menu_items/album_cart_menu_item.dart';
import 'menu_items/menu_item.dart';

class AlbumMenuWidget extends StatelessWidget {
  AlbumMenuWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.priceEtb,
    required this.priceUsd,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.albumId,
    required this.isLiked,
    required this.isBought,
    required this.album,
    required this.rootContext,
  }) : super(key: key);

  final int albumId;
  final String title;
  final String imageUrl;
  final double priceEtb;
  final double priceUsd;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool isFree;
  final bool isLiked;
  final bool isBought;
  final Album album;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil(context: context).getScreenHeight(),
      decoration: BoxDecoration(
        gradient: AppGradients().getMenuGradient(),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: AppMargin.margin_48,
                ),
                child: AppBouncingButton(
                  child: Icon(
                    PhosphorIcons.caret_circle_down_light,
                    color: AppColors.darkGrey,
                    size: AppIconSizes.icon_size_32,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil(context: context).getScreenHeight() * 0.2,
              ),
              buildMenuHeader(),
              SizedBox(
                height: AppMargin.margin_32,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                ),
                child: Column(
                  children: [
                    (!album.isBought && !album.isFree)
                        ? MenuItem(
                            isDisabled: false,
                            hasTopMargin: false,
                            iconColor: AppColors.grey.withOpacity(0.6),
                            icon: PhosphorIcons.currency_circle_dollar_thin,
                            title: AppLocale.of().buyAlbum,
                            onTap: () {},
                          )
                        : SizedBox(),
                    AlbumCartMenuItem(album: album),
                    AlbumFavoriteMenuItem(
                      hasTopMargin: true,
                      isDisabled: false,
                      isLiked: isLiked,
                      albumId: albumId,
                    ),
                    MenuItem(
                      isDisabled: false,
                      hasTopMargin: true,
                      iconColor: AppColors.grey.withOpacity(0.6),
                      icon: PhosphorIcons.user_light,
                      title: AppLocale.of().viewArtist,
                      onTap: () {
                        Navigator.pop(context);
                        PagesUtilFunctions.artistItemOnClick(
                          album.artist,
                          rootContext,
                        );
                      },
                    ),
                    MenuItem(
                      isDisabled: false,
                      hasTopMargin: true,
                      iconColor: AppColors.grey.withOpacity(0.6),
                      icon: PhosphorIcons.share_network_light,
                      title: AppLocale.of().shareAlbum,
                      onTap: () {},
                    ),
                    SizedBox(height: AppMargin.margin_20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMenuHeader() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            height: AppValues.menuHeaderImageSize,
            width: AppValues.menuHeaderImageSize,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => buildImagePlaceHolder(),
            errorWidget: (context, url, error) => buildImagePlaceHolder(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppMargin.margin_2),
          SmallTextPriceWidget(
            priceEtb: priceEtb,
            priceUsd: priceUsd,
            isFree: isFree,
            discountPercentage: discountPercentage,
            isDiscountAvailable: isDiscountAvailable,
            isPurchased: isBought,
          )
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
