import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_all_songs_bloc/purchased_all_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/library_data/purchased_song.dart';
import 'package:elf_play/data/models/song.dart';
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

class PurchasedAllSongsPage extends StatefulWidget {
  const PurchasedAllSongsPage({
    Key? key,
    required this.onSongsLoaded,
  }) : super(key: key);

  final Function(List<Song>) onSongsLoaded;

  @override
  _PurchasedAllSongsPageState createState() => _PurchasedAllSongsPageState();
}

class _PurchasedAllSongsPageState extends State<PurchasedAllSongsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL PURCHASED SONGS
    BlocProvider.of<PurchasedAllSongsBloc>(context)
        .add(LoadAllPurchasedSongsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<PurchasedAllSongsBloc, PurchasedAllSongsState>(
      builder: (context, state) {
        if (state is PurchasedAllSongsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is AllPurchasedSongsLoadedState) {
          ///PASS ALL LOADED SONGS TO PREVIOUS PAGE
          widget.onSongsLoaded(
            state.allPurchasedSong.map((e) => e.song).toList(),
          );
          if (state.allPurchasedSong.length > 0) {
            return buildPageLoaded(state.allPurchasedSong);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.folder_fill,
                msg: "You don't have any\nPurchases",
              ),
            );
          }
        } else if (state is PurchasedAllSongsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<PurchasedAllSongsBloc>(context)
                    .add(LoadAllPurchasedSongsEvent());
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

  Widget buildPageLoaded(List<PurchasedSong> allPurchasedSong) {
    return Column(
      children: [
        AutoDownloadRadio(downloadAllSelected: true),
        SizedBox(height: AppMargin.margin_8),
        buildSongsList(allPurchasedSong)
      ],
    );
  }

  ListView buildSongsList(List<PurchasedSong> allPurchasedSong) {
    return ListView.builder(
      itemCount: allPurchasedSong.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: [
            SizedBox(height: AppMargin.margin_8),
            SongItem(
              song: allPurchasedSong[position].song,
              isForMyPlaylist: false,
              thumbUrl: AppApi.baseFileUrl +
                  allPurchasedSong[position].song.albumArt.imageSmallPath,
              thumbSize: AppValues.playlistSongItemSize,
              onPressed: () {
                //OPEN SONG
                PagesUtilFunctions.openSong(
                  context: context,
                  songs: allPurchasedSong.map((e) => e.song).toList(),
                  startPlaying: true,
                  playingFrom: PlayingFrom(
                    from: "playing from",
                    title: "purchased mezmurs",
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
