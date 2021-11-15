import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/favorite_songs_bloc/favorite_songs_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/library_data/favorite_song.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_error_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';

class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({Key? key, required this.onSongsLoaded})
      : super(key: key);

  final Function(List<Song>) onSongsLoaded;

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
          ///PASS ALL LOADED SONGS TO PREVIOUS PAGE
          widget.onSongsLoaded(
            state.favoriteSongs.map((e) => e.song).toList(),
          );
          if (state.favoriteSongs.length > 0) {
            return buildPageLoaded(state.favoriteSongs);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.heart_straight_fill,
                msg: AppLocale.of().uDontHaveFavMezmurs,
              ),
            );
          }
        } else if (state is FavoriteSongsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<FavoriteSongsBloc>(context).add(
                  LoadFavoriteSongsEvent(),
                );
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
              thumbUrl: AppApi.baseUrl +
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
                    from: AppLocale.of().playingFrom,
                    title: AppLocale.of().favoriteMezmurs,
                    songSyncPlayedFrom: SongSyncPlayedFrom.FAVORITE_SONG,
                    songSyncPlayedFromId: -1,
                  ),
                  index: position,
                );
              },
              isForMyPlaylist: false,
            ),
            SizedBox(height: AppMargin.margin_8),
          ],
        );
      },
    );
  }
}
