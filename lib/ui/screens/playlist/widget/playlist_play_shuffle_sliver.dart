import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/share_buttons_bloc/share_buttons_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/like_follow/playlist_sliver_follow_button.dart';
import 'package:mehaley/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:mehaley/ui/common/sliver_small_text_button.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class PlaylistPlayShuffleSliver extends StatelessWidget {
  const PlaylistPlayShuffleSliver({
    Key? key,
    required this.songs,
    required this.playlist,
  }) : super(key: key);

  final List<Song> songs;
  final Playlist playlist;

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
                color: ColorMapper.getWhite(),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: ColorUtil.darken(ColorMapper.getWhite(), 0.1),
                    spreadRadius: 2,
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
                    width: AppMargin.margin_8,
                  ),

                  ///SHARE BUTTON
                  SliverSmallTextButton(
                    onTap: () {
                      BlocProvider.of<ShareButtonsBloc>(context).add(
                        SharePlaylistEvent(playlist: playlist),
                      );
                    },
                    text: AppLocale.of().share.toUpperCase(),
                    textColor: ColorMapper.getBlack(),
                    icon: FlutterRemix.share_line,
                    iconSize: AppIconSizes.icon_size_20,
                    iconColor: ColorMapper.getDarkOrange(),
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
                          from: AppLocale.of().playingFromPlaylist,
                          title: L10nUtil.translateLocale(
                              playlist.playlistNameText, context),
                          songSyncPlayedFrom:
                              SongSyncPlayedFrom.PLAYLIST_DETAIL,
                          songSyncPlayedFromId: playlist.playlistId,
                        ),
                        index: PagesUtilFunctions.getRandomIndex(
                            min: 0, max: songs.length),
                      );
                    },
                  ),

                  Expanded(child: SizedBox()),

                  ///FAV BUTTON
                  PlaylistSliverFollowButton(
                    iconSize: AppIconSizes.icon_size_16,
                    playlistId: playlist.playlistId,
                    isFollowing: playlist.isFollowed!,
                    iconColor: ColorMapper.getDarkOrange(),
                  ),

                  SizedBox(
                    width: AppMargin.margin_8,
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
