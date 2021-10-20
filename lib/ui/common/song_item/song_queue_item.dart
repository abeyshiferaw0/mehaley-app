import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';
import '../like_follow/song_is_liked_indicator.dart';

class SongQueueItem extends StatelessWidget {
  const SongQueueItem({
    Key? key,
    required this.position,
    required this.onPressed,
    required this.song,
  }) : super(key: key);

  final int position;
  final VoidCallback onPressed;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppMargin.margin_8,
          horizontal: AppMargin.margin_16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$position",
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: AppColors.white.withOpacity(0.9),
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(width: AppMargin.margin_16),
            AppCard(
              radius: 0.0,
              child: CachedNetworkImage(
                width: AppValues.queueSongItemSize,
                height: AppValues.queueSongItemSize,
                fit: BoxFit.cover,
                imageUrl: AppApi.baseFileUrl + song.albumArt.imageMediumPath,
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
            SizedBox(width: AppMargin.margin_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10nUtil.translateLocale(song.songName, context),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      color: AppColors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_2,
                  ),
                  Text(
                    PagesUtilFunctions.getArtistsNames(
                        song.artistsName, context),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      color: AppColors.txtGrey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            SongIsLikedIndicator(
              songId: song.songId,
              isLiked: song.isLiked,
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            Icon(
              PhosphorIcons.list_light,
              color: AppColors.lightGrey,
              size: AppIconSizes.icon_size_16,
            )
          ],
        ),
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
