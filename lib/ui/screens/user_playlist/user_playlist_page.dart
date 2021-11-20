import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_page_bloc/user_playlist_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/user_playlist/widget/user_playlist_sliver_deligates.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

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
              bgColor: AppColors.darkGrey,
              isFloating: true,
              msg: AppLocale.of().songRemovedPlaylist(
                songName: L10nUtil.translateLocale(
                  state.song.songName,
                  context,
                ),
                playlistName: L10nUtil.translateLocale(
                  state.myPlaylist.playlistNameText,
                  context,
                ),
              ),
              txtColor: AppColors.white,
              icon: FlutterRemix.checkbox_circle_fill,
              iconColor: AppColors.darkOrange,
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
              bgColor: AppColors.darkGrey,
              isFloating: true,
              msg: AppLocale.of().playlistDeleted(
                playlistName: L10nUtil.translateLocale(
                  state.myPlaylist.playlistNameText,
                  context,
                ),
              ),
              txtColor: AppColors.white,
              icon: FlutterRemix.checkbox_circle_fill,
              iconColor: AppColors.darkOrange,
            ),
          );
          Navigator.pop(context, state.myPlaylist);
        }

        ///REQUEST FAILURE MESSAGE
        if (state is UserPlaylistLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: AppLocale.of().unableToRemoveFromPlaylist,
              bgColor: AppColors.darkGrey,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: FlutterRemix.wifi_off_line,
            ),
          );
        }

        if (state is UserPlaylistDeletingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: AppLocale.of().unableToDeletePlaylist,
              bgColor: AppColors.darkGrey,
              isFloating: false,
              iconColor: AppColors.errorRed,
              icon: FlutterRemix.wifi_off_line,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
        body: BlocBuilder<UserPlaylistPageBloc, UserPlaylistPageState>(
          builder: (context, state) {
            if (state is UserPlaylistPageLoadingState) {
              return AppLoading(size: AppValues.loadingWidgetSize * 0.8);
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
                bgWidget: AppLoading(size: AppValues.loadingWidgetSize * 0.8),
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
            color: AppColors.white.withOpacity(
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
                      // UserPlaylistAddMezmursBtn(
                      //   makeSolid: false,
                      // ),
                      //SizedBox(height: AppMargin.margin_16),
                      // DownloadAllPurchased(
                      //   downloadAllSelected: downloadAllSelected,
                      // ),
                      //SizedBox(height: AppMargin.margin_16),
                    ],
                  )
                : SizedBox(),
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
                    color: AppColors.grey.withOpacity(0.2),
                  ),
                );
              },
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
                      thumbUrl: AppApi.baseUrl +
                          songs[position].albumArt.imageSmallPath,
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
