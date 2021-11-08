import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';

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
            color: AppColors.black,
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
                      from: AppLocalizations.of(context)!.playingFromArtist,
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
