import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_songs_bloc/purchased_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/library_data/purchased_song.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/library/widgets/auto_download.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_error_widget.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class PurchasedSongsPage extends StatefulWidget {
  const PurchasedSongsPage({Key? key, required this.onSongsLoaded})
      : super(key: key);

  final Function(List<Song>) onSongsLoaded;

  @override
  _PurchasedSongsPageState createState() => _PurchasedSongsPageState();
}

class _PurchasedSongsPageState extends State<PurchasedSongsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL PURCHASED SONGS
    BlocProvider.of<PurchasedSongsBloc>(context).add(LoadPurchasedSongsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<PurchasedSongsBloc, PurchasedSongsState>(
      builder: (context, state) {
        if (state is PurchasedSongsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is PurchasedSongsLoadedState) {
          ///PASS ALL LOADED SONGS TO PREVIOUS PAGE
          widget.onSongsLoaded(
            state.purchasedSongs.map((e) => e.song).toList(),
          );
          if (state.purchasedSongs.length > 0) {
            return buildPageLoaded(state.purchasedSongs);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.music_note_simple_light,
                msg: AppLocale.of().uDontHavePurchasedMezmurs,
              ),
            );
          }
        } else if (state is PurchasedSongsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<PurchasedSongsBloc>(context)
                    .add(LoadPurchasedSongsEvent());
              },
            ),
          );
        }
        return buildAppLoading(context, screenHeight);
      },
    );
  }

  Container buildAppLoading(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight * 0.5,
      child: AppLoading(size: AppValues.loadingWidgetSize / 2),
    );
  }

  Widget buildPageLoaded(List<PurchasedSong> purchasedSong) {
    return Column(
      children: [
        AutoDownloadRadio(downloadAllSelected: true),
        SizedBox(height: AppMargin.margin_8),
        buildPlaylistSongList(purchasedSong)
      ],
    );
  }

  ListView buildPlaylistSongList(List<PurchasedSong> purchasedSong) {
    return ListView.builder(
      itemCount: purchasedSong.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: [
            SizedBox(height: AppMargin.margin_8),
            SongItem(
              song: purchasedSong[position].song,
              isForMyPlaylist: false,
              thumbUrl: AppApi.baseUrl +
                  purchasedSong[position].song.albumArt.imageSmallPath,
              thumbSize: AppValues.playlistSongItemSize,
              onPressed: () {
                //OPEN SONG
                PagesUtilFunctions.openSong(
                  context: context,
                  songs: purchasedSong.map((e) => e.song).toList(),
                  startPlaying: true,
                  playingFrom: PlayingFrom(
                    from: AppLocale.of().playingFrom,
                    title: AppLocale.of().purchasedMezmurs,
                    songSyncPlayedFrom: SongSyncPlayedFrom.PURCHASED_SONG,
                    songSyncPlayedFromId: -1,
                  ),
                  index: position,
                );
              },
            ),
            SizedBox(height: AppMargin.margin_8),
          ],
        );
      },
    );
  }
}
