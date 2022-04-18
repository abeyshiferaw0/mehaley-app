import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/business_logic/blocs/playlist_page_bloc/playlist_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/playlist_page_data.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/playlist/widget/playlist_sliver_deligates.dart';
import 'package:mehaley/ui/screens/playlist/widget/shimmer_playlist.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key, required this.playlistId}) : super(key: key);

  final int playlistId;

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  //DEBUG
  bool downloadAllSelected = true;
  //DEBUG

  @override
  void initState() {
    BlocProvider.of<PlaylistPageBloc>(context)
        .add(LoadPlaylistPageEvent(playlistId: widget.playlistId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      body: SafeArea(
        child: Container(
          color: ColorMapper.getPagesBgColor(),
          child: BlocBuilder<PlaylistPageBloc, PlaylistPageState>(
            builder: (context, state) {
              if (state is PlaylistPageLoadingState) {
                return buildPlaylistPageLoading();
              }
              if (state is PlaylistPageLoadedState) {
                ///CHANGE PLAYLIST DOMINANT COLOR
                BlocProvider.of<PagesDominantColorBloc>(context).add(
                  PlaylistPageDominantColorChanged(
                    dominantColor: state.playlistPageData.playlist.playlistImage
                        .primaryColorHex,
                  ),
                );
                return buildPlaylistPageLoaded(state.playlistPageData);
              }
              if (state is PlaylistPageLoadingErrorState) {
                return AppError(
                  bgWidget: buildPlaylistPageLoading(),
                  onRetry: () {
                    BlocProvider.of<PlaylistPageBloc>(context).add(
                      LoadPlaylistPageEvent(playlistId: widget.playlistId),
                    );
                  },
                );
              }
              return buildPlaylistPageLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget buildPlaylistPageLoading() {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: ColorMapper.getWhite(),
              child: AppLoading(size: AppValues.loadingWidgetSize),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: ColorMapper.getPagesBgColor(),
                boxShadow: [
                  BoxShadow(
                    color: ColorMapper.getCompletelyBlack().withOpacity(0.1),
                    offset: Offset(0, 0),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(AppPadding.padding_16),
              child: PlaylistShimmer(),
            ),
          ),
        ],
      ),
    );
  }

  NestedScrollView buildPlaylistPageLoaded(PlaylistPageData playlistPageData) {
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          buildSliverHeader(playlistPageData),
          buildSliverPlayShuffleButton(
            playlistPageData.songs,
            playlistPageData.playlist,
          ),
        ];
      },
      body: buildPlaylistSongList(
        playlistPageData.songs,
        playlistPageData.playlist,
      ),
    );
  }

  SliverPersistentHeader buildSliverHeader(playlistPageData) {
    return SliverPersistentHeader(
      delegate:
          PlaylistPageSliverHeaderDelegate(playlistPageData: playlistPageData),
      floating: true,
      pinned: true,
    );
  }

  SliverPersistentHeader buildSliverPlayShuffleButton(
      List<Song> songs, Playlist playlist) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: PlaylistPlayShuffleDelegate(songs: songs, playlist: playlist),
    );
  }

  Container buildPlaylistSongList(List<Song> songs, Playlist playlist) {
    return Container(
      padding: const EdgeInsets.only(left: AppPadding.padding_16),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppMargin.margin_16),
            //DownloadAllPurchased(downloadAllSelected: downloadAllSelected),

            SizedBox(height: AppMargin.margin_32),
            ListView.separated(
              itemCount: songs.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              separatorBuilder: (BuildContext context, int position) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.padding_4,
                  ),
                  child: Divider(
                    color: ColorMapper.getGrey().withOpacity(0.2),
                  ),
                );
              },
              itemBuilder: (BuildContext context, int position) {
                return SongItem(
                  song: songs[position],
                  isForMyPlaylist: false,
                  thumbUrl: songs[position].albumArt.imageMediumPath,
                  thumbSize: AppValues.playlistSongItemSize,
                  onPressed: () {
                    //OPEN SONG
                    PagesUtilFunctions.openSong(
                      context: context,
                      songs: songs,
                      startPlaying: true,
                      playingFrom: PlayingFrom(
                        from: AppLocale.of().playingFromPlaylist,
                        title: L10nUtil.translateLocale(
                            playlist.playlistNameText, context),
                        songSyncPlayedFrom: SongSyncPlayedFrom.PLAYLIST_DETAIL,
                        songSyncPlayedFromId: playlist.playlistId,
                      ),
                      index: position,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
