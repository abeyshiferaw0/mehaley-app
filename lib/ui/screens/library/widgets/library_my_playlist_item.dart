import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/util/pages_util_functions.dart';
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
            Container(
              width: AppValues.libraryMusicItemSize,
              height: AppValues.libraryMusicItemSize,
              child: PagesUtilFunctions.getSongGridImage(myPlaylist),
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
}
