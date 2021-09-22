import 'package:elf_play/business_logic/blocs/library_page_bloc/offline_songs_bloc/offline_songs_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/library/widgets/auto_download.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class OfflineSongsPage extends StatefulWidget {
  const OfflineSongsPage({Key? key}) : super(key: key);

  @override
  _OfflineSongsPageState createState() => _OfflineSongsPageState();
}

class _OfflineSongsPageState extends State<OfflineSongsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL DOWNLOADED SONGS
    BlocProvider.of<OfflineSongsBloc>(context).add(
      LoadOfflineSongsEvent(),
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
          if (state.offlineSongs.length > 0) {
            return buildPageLoaded(state.offlineSongs);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.folder_fill,
                msg: "You don't have any Offline\nmezmurs",
              ),
            );
          }
        } else if (state is OfflineSongsLoadingErrorState) {
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
              thumbUrl: AppApi.baseFileUrl +
                  offlineSong[position].albumArt.imageSmallPath,
              thumbSize: AppValues.offlineSongsSize,
              onPressed: () {
                //OPEN SONG
                PagesUtilFunctions.openSong(
                  context: context,
                  songs: offlineSong,
                  startPlaying: true,
                  playingFrom: PlayingFrom(
                    from: "playing from",
                    title: "offline mezmurs",
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
