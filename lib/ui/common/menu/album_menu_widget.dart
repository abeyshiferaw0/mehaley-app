import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/share_buttons_bloc/share_buttons_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/menu/menu_items/album_favorite_menu_item.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';
import '../player_items_placeholder.dart';
import '../small_text_price_widget.dart';
import 'menu_items/menu_item.dart';

class AlbumMenuWidget extends StatelessWidget {
  AlbumMenuWidget({
    Key? key,
    required this.album,
    required this.onViewArtistClicked,
    required this.onBuyAlbumClicked,
  }) : super(key: key);

  final Album album;
  final VoidCallback onViewArtistClicked;
  final VoidCallback onBuyAlbumClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppValues.menuBottomSheetRadius),
          topRight: Radius.circular(AppValues.menuBottomSheetRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildMenuHeader(context),
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
                          iconColor: ColorMapper.getGrey().withOpacity(0.6),
                          icon: FlutterRemix.money_dollar_circle_line,
                          title: AppLocale.of().buyAlbum,
                          onTap: () {
                            Navigator.pop(context);
                            onBuyAlbumClicked();
                          },
                        )
                      : SizedBox(),
                  AlbumFavoriteMenuItem(
                    hasTopMargin: true,
                    isDisabled: false,
                    isLiked: album.isLiked,
                    albumId: album.albumId,
                    unlikedColor: ColorMapper.getGrey().withOpacity(0.6),
                    likedColor: ColorMapper.getDarkOrange(),
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: ColorMapper.getGrey().withOpacity(0.6),
                    icon: FlutterRemix.user_voice_line,
                    title: AppLocale.of().viewArtist,
                    onTap: () {
                      Navigator.pop(context);
                      onViewArtistClicked();
                    },
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: ColorMapper.getGrey().withOpacity(0.6),
                    icon: FlutterRemix.share_line,
                    title: AppLocale.of().shareAlbum,
                    onTap: () {
                      BlocProvider.of<ShareButtonsBloc>(context).add(
                        ShareAlbumEvent(album: album),
                      );
                    },
                  ),
                  SizedBox(height: AppMargin.margin_20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildMenuHeader(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppPadding.padding_20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppCard(
            withShadow: false,
            radius: 6.0,
            child: CachedNetworkImage(
              height: AppValues.menuHeaderImageSize,
              width: AppValues.menuHeaderImageSize,
              imageUrl: album.albumImages[0].imageMediumPath,
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
          ),
          SizedBox(width: AppMargin.margin_16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10nUtil.translateLocale(album.albumTitle, context),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: ColorMapper.getBlack(),
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppMargin.margin_2),
              SmallTextPriceWidget(
                priceEtb: album.priceEtb,
                priceUsd: album.priceDollar,
                isFree: album.isFree,
                discountPercentage: album.discountPercentage,
                isDiscountAvailable: album.isDiscountAvailable,
                isPurchased: album.isBought,
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
