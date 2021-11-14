import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/ui/common/like_follow/artist_follow_button.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
              imageUrl: AppApi.baseUrl + artist.artistImages[0].imageMediumPath,
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
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_12.sp,
              ),
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Container(
            width: AppIconSizes.icon_size_24,
            height: AppIconSizes.icon_size_24,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.circle,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_12,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    PhosphorIcons.circle_wavy_check_fill,
                    color: AppColors.green,
                    size: AppIconSizes.icon_size_24,
                  ),
                ),
              ],
            ),
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
