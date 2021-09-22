import 'package:elf_play/business_logic/blocs/library_page_bloc/favorite_songs_bloc/favorite_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/library_data/favorite_song.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({Key? key}) : super(key: key);

  @override
  _FavoriteSongsPageState createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL FAVORITE SONGS
    BlocProvider.of<FavoriteSongsBloc>(context).add(
      LoadFavoriteSongsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<FavoriteSongsBloc, FavoriteSongsState>(
      builder: (context, state) {
        if (state is FavoriteSongsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is FavoriteSongsLoadedState) {
          if (state.favoriteSongs.length > 0) {
            return buildPageLoaded(state.favoriteSongs);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.folder_fill,
                msg: "You don't have any favorite\nmezmurs",
              ),
            );
          }
        } else if (state is FavoriteSongsLoadingErrorState) {
          return Container(
            height: screenHeight * 0.5,
            child: Text(
              state.error,
              style: TextStyle(
                color: AppColors.errorRed,
              ),
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
      child: AppLoading(size: AppValues.loadingWidgetSize),
    );
  }

  Widget buildPageLoaded(List<FavoriteSong> favoriteSongs) {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_8),
        buildSongsList(favoriteSongs)
      ],
    );
  }

  ListView buildSongsList(List<FavoriteSong> favoriteSongs) {
    return ListView.builder(
      itemCount: favoriteSongs.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: [
            SizedBox(height: AppMargin.margin_8),
            SongItem(
              thumbUrl: AppApi.baseFileUrl +
                  favoriteSongs[position].song.albumArt.imageSmallPath,
              song: favoriteSongs[position].song,
              thumbSize: AppValues.playlistSongItemSize,
              onPressed: () {
                //OPEN SONG
                PagesUtilFunctions.openSong(
                  context: context,
                  songs: favoriteSongs.map((e) => e.song).toList(),
                  startPlaying: true,
                  playingFrom: PlayingFrom(
                    from: "playing from",
                    title: "favorite mezmurs",
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
