import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/offline_songs_bloc/offline_songs_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/library/widgets/auto_download.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_error_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';

class OfflineSongsPage extends StatefulWidget {
  const OfflineSongsPage({Key? key, required this.onSongsLoaded})
      : super(key: key);

  final Function(List<Song>) onSongsLoaded;

  @override
  _OfflineSongsPageState createState() => _OfflineSongsPageState();
}

class _OfflineSongsPageState extends State<OfflineSongsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL DOWNLOADED SONGS
    BlocProvider.of<OfflineSongsBloc>(context).add(
      LoadOfflineSongsEvent(
        appLibrarySortTypes: AppLibrarySortTypes.LATEST_DOWNLOAD,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<OfflineSongsBloc, OfflineSongsState>(
      builder: (context, state) {
        if (state is OfflineSongsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is OfflineSongsLoadedState) {
          ///PASS ALL LOADED SONGS TO PREVIOUS PAGE
          widget.onSongsLoaded(state.offlineSongs);
          if (state.offlineSongs.length > 0) {
            return buildPageLoaded(state.offlineSongs);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                emptyOffline: true,
                icon: FlutterRemix.arrow_down_circle_fill,
                msg: AppLocale.of().uDontHaveDownloads,
              ),
            );
          }
        } else if (state is OfflineSongsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<OfflineSongsBloc>(context).add(
                  LoadOfflineSongsEvent(
                    appLibrarySortTypes: AppLibrarySortTypes.LATEST_DOWNLOAD,
                  ),
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

  Widget buildPageLoaded(List<Song> offlineSong) {
    return Column(
      children: [
        AutoDownloadRadio(downloadAllSelected: true),
        SizedBox(height: AppMargin.margin_8),
        buildOfflineSongList(offlineSong)
      ],
    );
  }

  ListView buildOfflineSongList(List<Song> offlineSong) {
    return ListView.builder(
      itemCount: offlineSong.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Column(
          children: [
            SizedBox(height: AppMargin.margin_8),
            SongItem(
              song: offlineSong[position],
              isForMyPlaylist: false,
              thumbUrl: AppApi.baseUrl +
                  offlineSong[position].albumArt.imageSmallPath,
              thumbSize: AppValues.offlineSongsSize,
              onPressed: () {
                //OPEN SONG
                PagesUtilFunctions.openSong(
                  context: context,
                  songs: offlineSong,
                  startPlaying: true,
                  playingFrom: PlayingFrom(
                    from: AppLocale.of().playingFrom,
                    title: AppLocale.of().offlineMezmurs,
                    songSyncPlayedFrom: SongSyncPlayedFrom.OFFLINE_PAGE,
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
