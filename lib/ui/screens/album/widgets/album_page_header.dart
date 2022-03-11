import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/buy_item_btn.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';

import 'album_play_shuffle_header.dart';

class AlbumPageHeader extends StatefulWidget {
  const AlbumPageHeader({Key? key, required this.album, required this.songs})
      : super(key: key);

  final Album album;
  final List<Song> songs;

  @override
  _AlbumPageHeaderState createState() =>
      _AlbumPageHeaderState(album: album, songs: songs);
}

class _AlbumPageHeaderState extends State<AlbumPageHeader>
    with TickerProviderStateMixin {
  /////////////////////
  final Album album;
  final List<Song> songs;

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColorBlack;

  _AlbumPageHeaderState({required this.songs, required this.album});

  //ALBUM SUB TITLE TEXT STYLE
  final TextStyle albumSubTitleStyle = TextStyle(
    fontSize: AppFontSizes.font_size_12,
    color: ColorMapper.getTxtGrey(),
    letterSpacing: 0.0,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is HomePageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: ColorMapper.getWhite(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppMargin.margin_32),
                  buildAlbumArt(album),
                  SizedBox(height: AppMargin.margin_16),
                  buildTitleAndSubTitle(album),
                  SizedBox(height: AppMargin.margin_20),
                  album.isBought
                      ? SmallTextPriceWidget(
                          priceEtb: album.priceEtb,
                          priceUsd: album.priceDollar,
                          isFree: album.isFree,
                          useLargerText: true,
                          showDiscount: true,
                          useDimColor: true,
                          isDiscountAvailable: album.isDiscountAvailable,
                          discountPercentage: album.discountPercentage,
                          isPurchased: album.isBought,
                        )
                      : album.isFree || album.isBought
                          ? SizedBox()
                          : BuyItemBtnWidget(
                              priceEtb: album.priceEtb,
                              priceUsd: album.priceDollar,
                              title: AppLocale.of().buyAlbum.toUpperCase(),
                              hasLeftMargin: false,
                              isFree: album.isFree,
                              discountPercentage: album.discountPercentage,
                              isDiscountAvailable: album.isDiscountAvailable,
                              isBought: album.isBought,
                              onBuyClicked: () {
                                PurchaseUtil.albumPageHeaderBuyButtonOnClick(
                                  context,
                                  album,
                                );
                              },
                            ),
                  SizedBox(height: AppMargin.margin_16),
                ],
              ),
            ),
            AlbumPlayShuffleHeader(
              album: album,
              songs: songs,
            ),
          ],
        );
      },
    );
  }

  AppCard buildAlbumArt(Album album) {
    return AppCard(
      withShadow: false,
      radius: 4.0,
      child: CachedNetworkImage(
        width: AppValues.albumPageImageSize,
        height: AppValues.albumPageImageSize,
        fit: BoxFit.cover,
        imageUrl: album.albumImages[0].imageMediumPath,
        imageBuilder: (context, imageProvider) {
          //CHANGE DOMINANT COLOR
          BlocProvider.of<PagesDominantColorBloc>(context).add(
            AlbumPageDominantColorChanged(
              dominantColor: album.albumImages[0].primaryColorHex,
            ),
          );
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) => buildItemsImagePlaceHolder(),
        errorWidget: (context, url, e) => buildItemsImagePlaceHolder(),
      ),
    );
  }

  Column buildTitleAndSubTitle(Album album) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          L10nUtil.translateLocale(album.albumTitle, context),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_24,
            color: ColorMapper.getBlack(),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppMargin.margin_4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${AppLocale.of().albumBy} ${L10nUtil.translateLocale(album.artist.artistName, context)}',
              style: albumSubTitleStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(AppMargin.margin_4),
              child: Icon(
                Icons.circle,
                size: AppIconSizes.icon_size_4,
                color: ColorMapper.getTxtGrey(),
              ),
            ),
            Text(
              PagesUtilFunctions.getAlbumYear(album),
              style: albumSubTitleStyle,
            ),
          ],
        ),
      ],
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ALBUM);
  }
}
