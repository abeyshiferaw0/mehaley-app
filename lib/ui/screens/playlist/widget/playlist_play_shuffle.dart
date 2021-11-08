import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistPlayShuffle extends StatelessWidget {
  const PlaylistPlayShuffle({
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
              color: AppColors.black,
            ),
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
                    songs: songs,
                    playingFrom: PlayingFrom(
                      from: AppLocalizations.of(context)!.playingFromPlaylist,
                      title: L10nUtil.translateLocale(playlist.playlistNameText, context),
                      songSyncPlayedFrom: SongSyncPlayedFrom.PLAYLIST_DETAIL,
                      songSyncPlayedFromId: playlist.playlistId,
                    ),
                    index: PagesUtilFunctions.getRandomIndex(min: 0, max: songs.length),
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
