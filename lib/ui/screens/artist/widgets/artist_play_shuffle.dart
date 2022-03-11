import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class ArtistPlayShuffle extends StatelessWidget {
  const ArtistPlayShuffle({
    Key? key,
    required this.popularSongs,
    required this.artist,
  }) : super(key: key);

  final List<Song> popularSongs;
  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          Container(
            height: 40,
            color: ColorMapper.getWhite(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Center(
              child: PlayShuffleLgBtnWidget(
                onTap: () {
                  //OPEN SHUFFLE SONGS
                  PagesUtilFunctions.openSongShuffled(
                    context: context,
                    startPlaying: true,
                    songs: popularSongs,
                    playingFrom: PlayingFrom(
                      from: AppLocale.of().playingFromArtist,
                      title:
                          L10nUtil.translateLocale(artist.artistName, context),
                      songSyncPlayedFrom: SongSyncPlayedFrom.ARTIST_DETAIL,
                      songSyncPlayedFromId: artist.artistId,
                    ),
                    index: PagesUtilFunctions.getRandomIndex(
                        min: 0, max: popularSongs.length),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
