import 'package:elf_play/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:elf_play/business_logic/blocs/user_playlist_page_bloc/user_playlist_page_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/download_all_purchased.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/playlist/widget/shimmer_playlist.dart';
import 'package:elf_play/ui/screens/user_playlist/widget/user_palaylist_add_songs_button.dart';
import 'package:elf_play/ui/screens/user_playlist/widget/user_playlist_sliver_deligates.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class UserPlaylistPage extends StatefulWidget {
  const UserPlaylistPage({Key? key, required this.playlistId})
      : super(key: key);

  final int playlistId;

  @override
  _UserPlaylistPageState createState() => _UserPlaylistPageState();
}

class _UserPlaylistPageState extends State<UserPlaylistPage> {
  //DEBUG
  bool downloadAllSelected = true;

  //DEBUG

  @override
  void initState() {
    BlocProvider.of<UserPlaylistPageBloc>(context).add(
      LoadUserPlaylistPageEvent(playlistId: widget.playlistId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserPlaylistBloc, UserPlaylistState>(
      listener: (context, state) {
        ///REQUEST SUCCESS MESSAGE
        if (state is SongRemovedFromPlaylistState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.white,
              isFloating: true,
              msg:
                  "${state.song.songName.textAm} removed from ${state.myPlaylist.playlistNameText.textAm}",
              txtColor: AppColors.black,
              icon: PhosphorIcons.check_circle_fill,
              iconColor: AppColors.darkGreen,
            ),
          );

          ///REMOVE REMOVED SONG TEMPORARILY
          BlocProvider.of<UserPlaylistPageBloc>(context).add(
            SongRemovedFromPlaylistEvent(
                song: state.song, playlistId: widget.playlistId),
          );
        }

        if (state is UserPlaylistDeletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.white,
              isFloating: true,
              msg: "${state.myPlaylist.playlistNameText.textAm} deleted",
              txtColor: AppColors.black,
              icon: PhosphorIcons.check_circle_fill,
              iconColor: AppColors.darkGreen,
            ),
          );
          Navigator.pop(context, state.myPlaylist);
        }

        ///REQUEST FAILURE MESSAGE
        if (state is UserPlaylistLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg:
                  "Unable remove mezmur from playlist\ncheck your internet connection",
              bgColor: AppColors.white,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: PhosphorIcons.wifi_x_light,
            ),
          );
        }

        if (state is UserPlaylistDeletingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: "Unable to delete playlist\ncheck your internet connection",
              bgColor: AppColors.white,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: PhosphorIcons.wifi_x_light,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<UserPlaylistPageBloc, UserPlaylistPageState>(
          builder: (context, state) {
            if (state is UserPlaylistPageLoadingState) {
              return ShimmerPlaylist();
            }
            if (state is UserPlaylistPageLoadedState) {
              ///CHANGE DOMINANT COLOR OF USER PLAYLIST PAGE
              PagesUtilFunctions.changeUserPlaylistDominantColor(
                state.userPlaylistPageData.myPlaylist,
                context,
              );
              return buildUserPlaylistPageLoaded(
                state.userPlaylistPageData.songs,
                state.userPlaylistPageData.myPlaylist,
              );
            }
            if (state is UserPlaylistPageLoadingErrorState) {
              return AppError(
                bgWidget: ShimmerPlaylist(),
                onRetry: () {
                  BlocProvider.of<UserPlaylistPageBloc>(context).add(
                    LoadUserPlaylistPageEvent(playlistId: widget.playlistId),
                  );
                },
              );
            }
            return AppLoading(size: AppValues.loadingWidgetSize);
          },
        ),
      ),
    );
  }

  Stack buildUserPlaylistPageLoaded(List<Song> songs, MyPlaylist myPlaylist) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              buildSliverHeader(songs, myPlaylist),
              songs.length > 0
                  ? buildSliverPlayShuffleButton(songs, myPlaylist)
                  : buildSliverAddSongsButton(),
            ];
          },
          body: buildUserPlaylistSongList(
            songs,
            myPlaylist,
          ),
        ),
        buildDeletePlaylistLoading(),
      ],
    );
  }

  BlocBuilder buildDeletePlaylistLoading() {
    return BlocBuilder<UserPlaylistBloc, UserPlaylistState>(
      builder: (context, state) {
        if (state is UserPlaylistLoadingState) {
          return Container(
            color: AppColors.black.withOpacity(
              0.5,
            ),
            child: Center(
              child: AppLoading(
                size: AppValues.loadingWidgetSize,
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  SliverPersistentHeader buildSliverHeader(
      List<Song> songs, MyPlaylist myPlaylist) {
    return SliverPersistentHeader(
      delegate: UserPlaylistPageSliverHeaderDelegate(
        songs: songs,
        myPlaylist: myPlaylist,
      ),
      floating: true,
      pinned: true,
    );
  }

  SliverPersistentHeader buildSliverPlayShuffleButton(
      List<Song> songs, MyPlaylist myPlaylist) {
    return SliverPersistentHeader(
      pinned: true,
      delegate:
          UserPlaylistPlayShuffleDelegate(songs: songs, myPlaylist: myPlaylist),
    );
  }

  SliverPersistentHeader buildSliverAddSongsButton() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: UserAddSongsButtonDelegate(),
    );
  }

  Padding buildUserPlaylistSongList(List<Song> songs, MyPlaylist playlist) {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.padding_16),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            songs.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: AppMargin.margin_16),
                      UserPlaylistAddMezmursBtn(
                        makeSolid: false,
                      ),
                      SizedBox(height: AppMargin.margin_16),
                      DownloadAllPurchased(
                          downloadAllSelected: downloadAllSelected),
                      SizedBox(height: AppMargin.margin_16),
                    ],
                  )
                : SizedBox(),
            ListView.builder(
              itemCount: songs.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int position) {
                return Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    SongItem(
                      song: songs[position],
                      isForMyPlaylist: true,
                      onRemoveSongFromPlaylist: (song) {
                        BlocProvider.of<UserPlaylistBloc>(context).add(
                          RemoveSongUserPlaylistEvent(
                            myPlaylist: playlist,
                            song: song,
                          ),
                        );
                      },
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
                            songSyncPlayedFrom:
                                SongSyncPlayedFrom.USER_PLAYLIST,
                            songSyncPlayedFromId: playlist.playlistId,
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
          ],
        ),
      ),
    );
  }
}
