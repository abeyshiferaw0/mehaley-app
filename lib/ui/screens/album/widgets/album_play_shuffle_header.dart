import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/like_follow/album_header_favorite_button.dart';
import 'package:mehaley/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:mehaley/ui/common/sliver_small_circle_button.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class AlbumPlayShuffleHeader extends StatelessWidget {
  const AlbumPlayShuffleHeader({
    Key? key,
    required this.songs,
    required this.album,
  }) : super(key: key);

  final List<Song> songs;
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    color: ColorUtil.darken(AppColors.white, 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: AppMargin.margin_16,
                  ),

                  ///SHARE BUTTON
                  SliverSmallCircleButton(
                    onTap: () {},
                    icon: FlutterRemix.share_line,
                    iconSize: AppIconSizes.icon_size_20,
                    iconColor: AppColors.darkOrange,
                  ),

                  Expanded(child: SizedBox()),

                  ///PLAY SHUFFLE BUTTON
                  PlayShuffleLgBtnWidget(
                    onTap: () {
                      //OPEN SHUFFLE SONGS
                      PagesUtilFunctions.openSongShuffled(
                        context: context,
                        startPlaying: true,
                        songs: songs,
                        playingFrom: PlayingFrom(
                          from: AppLocale.of().playingFromAlbum,
                          title: L10nUtil.translateLocale(
                              album.albumTitle, context),
                          songSyncPlayedFrom: SongSyncPlayedFrom.ALBUM_DETAIL,
                          songSyncPlayedFromId: album.albumId,
                        ),
                        index: PagesUtilFunctions.getRandomIndex(
                          min: 0,
                          max: songs.length,
                        ),
                      );
                    },
                  ),

                  Expanded(child: SizedBox()),

                  ///FAV BUTTON
                  AlbumHeaderFavoriteButton(
                    isLiked: album.isLiked,
                    iconSize: AppIconSizes.icon_size_20,
                    albumId: album.albumId,
                    likedColor: AppColors.darkOrange,
                    unlikedColor: AppColors.darkOrange,
                  ),

                  SizedBox(
                    width: AppMargin.margin_16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
