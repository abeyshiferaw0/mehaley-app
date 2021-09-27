import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class LibraryMyPlaylistItem extends StatelessWidget {
  final MyPlaylist myPlaylist;
  final VoidCallback onTap;
  final bool isForSongAddToPlaylistPage;

  const LibraryMyPlaylistItem({
    required this.myPlaylist,
    required this.onTap,
    required this.isForSongAddToPlaylistPage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppCard(
              child: CachedNetworkImage(
                width: AppValues.libraryMusicItemSize,
                height: AppValues.libraryMusicItemSize,
                fit: BoxFit.cover,
                imageUrl: getPlaylistImageUrl(myPlaylist),
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
            SizedBox(width: AppMargin.margin_16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myPlaylist.playlistNameText.textAm,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppMargin.margin_2),
                  Text(
                    "${myPlaylist.numberOfSongs} Mezmurs",
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            isForSongAddToPlaylistPage
                ? Icon(
                    PhosphorIcons.plus_circle_light,
                    size: AppIconSizes.icon_size_24,
                    color: AppColors.lightGrey,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  String getPlaylistImageUrl(MyPlaylist myPlaylist) {
    if (myPlaylist.playlistImage != null) {
      return AppApi.baseFileUrl + myPlaylist.playlistImage!.imageMediumPath;
    }
    if (myPlaylist.playlistPlaceHolderImage != null) {
      return AppApi.baseFileUrl +
          myPlaylist.playlistPlaceHolderImage!.imageMediumPath;
    }
    return AppApi.baseFileUrl;
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
}
