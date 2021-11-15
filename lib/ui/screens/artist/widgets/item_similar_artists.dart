import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class ItemSimilarArtistsPlaylist extends StatelessWidget {
  final Artist artist;

  ItemSimilarArtistsPlaylist({required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PagesUtilFunctions.artistItemOnClick(artist, context);
      },
      child: Container(
        width: AppValues.similarItemImageSize,
        child: Padding(
          padding: EdgeInsets.only(top: AppPadding.padding_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppValues.similarItemImageSize,
                ),
                child: CachedNetworkImage(
                  width: AppValues.similarItemImageSize,
                  height: AppValues.similarItemImageSize,
                  imageUrl:
                      AppApi.baseUrl + artist.artistImages[0].imageMediumPath,
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
                    ],
                  ),
                  placeholder: (context, url) => buildItemsImagePlaceHolder(),
                  errorWidget: (context, url, error) =>
                      buildItemsImagePlaceHolder(),
                ),
              ),
              SizedBox(height: AppMargin.margin_8),
              Text(
                L10nUtil.translateLocale(artist.artistName, context),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: AppFontSizes.font_size_14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
  }
}
