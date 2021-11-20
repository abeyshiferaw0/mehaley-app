import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
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
      child: AppCard(
        radius: 6.0,
        withShadow: false,
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
                      L10nUtil.translateLocale(
                          myPlaylist.playlistNameText, context),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppMargin.margin_2),
                    Text(
                      AppLocale.of().numberOfMezmurs(
                          numberOf: myPlaylist.numberOfSongs.toString()),
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
                      FlutterRemix.add_circle_line,
                      size: AppIconSizes.icon_size_24,
                      color: AppColors.darkGrey,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
