import 'package:elf_play/business_logic/blocs/playlist_page_bloc/playlist_page_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/playlist/widget/playlist_sliver_deligates.dart';
import 'package:elf_play/ui/screens/playlist/widget/shimmer_playlist.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: AppColors.black,
      body: BlocBuilder<PlaylistPageBloc, PlaylistPageState>(
        builder: (context, state) {
          if (state is PlaylistPageLoadingState) {
            return ShimmerPlaylist();
          }
          if (state is PlaylistPageLoadedState) {
            return buildPlaylistPageLoaded(
              state.playlistPageData.songs,
              state.playlistPageData.playlist,
            );
          }
          if (state is PlaylistPageLoadingErrorState) {
            return AppError(
              bgWidget: ShimmerPlaylist(),
              onRetry: () {
                BlocProvider.of<PlaylistPageBloc>(context).add(
                  LoadPlaylistPageEvent(playlistId: widget.playlistId),
                );
              },
            );
          }
          return AppLoading(size: AppValues.loadingWidgetSize);
        },
      ),
    );
  }

  NestedScrollView buildPlaylistPageLoaded(
      List<Song> songs, Playlist playlist) {
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          buildSliverHeader(),
          buildSliverPlayShuffleButton(songs, playlist),
          // buildDownloadAllSection(),
        ];
      },
      body: buildPlaylistSongList(
        songs,
        playlist,
      ),
    );
  }

  SliverPersistentHeader buildSliverHeader() {
    return SliverPersistentHeader(
      delegate: PlaylistPageSliverHeaderDelegate(),
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

  Padding buildPlaylistSongList(List<Song> songs, Playlist playlist) {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.padding_16),
      child: ListView.builder(
        itemCount: songs.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Column(
            children: [
              SizedBox(height: AppMargin.margin_8),
              SongItem(
                song: songs[position],
                thumbUrl: AppApi.baseFileUrl +
                    songs[position].albumArt.imageSmallPath,
                thumbSize: AppValues.playlistSongItemSize,
                onPressed: () {
                  //OPEN SONG
                  PagesUtilFunctions.openSong(
                    context: context,
                    songs: songs,
                    startPlaying: true,
                    playingFrom: PlayingFrom(
                      from: "playing from playlist",
                      title: playlist.playlistNameText.textAm,
                    ),
                    index: position,
                  );
                },
              ),
              SizedBox(height: AppMargin.margin_8),
            ],
          );
        },
      ),
    );
  }
}
