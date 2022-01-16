import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/like_follow/artist_follow_button.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class LibraryArtistsItem extends StatelessWidget {
  final Artist artist;

  LibraryArtistsItem({required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PagesUtilFunctions.artistItemOnClick(artist, context);
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppValues.followedArtistImageSize,
            ),
            child: CachedNetworkImage(
              width: AppValues.followedArtistImageSize,
              height: AppValues.followedArtistImageSize,
              imageUrl: artist.artistImages[0].imageMediumPath,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => buildItemsImagePlaceHolder(),
              errorWidget: (context, url, error) =>
                  buildItemsImagePlaceHolder(),
            ),
          ),
          SizedBox(width: AppMargin.margin_16),
          Expanded(
            child: Text(
              L10nUtil.translateLocale(artist.artistName, context) +
                  L10nUtil.translateLocale(artist.artistName, context),
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_12.sp,
              ),
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Icon(
            FlutterRemix.checkbox_circle_fill,
            color: AppColors.orange,
            size: AppIconSizes.icon_size_24,
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          ArtistFollowButton(
            isFollowing: artist.isFollowed!,
            artistId: artist.artistId,
            askDialog: true,
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
  }
}
