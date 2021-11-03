import 'package:elf_play/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:elf_play/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_my_playlist_item.dart';
import 'package:elf_play/ui/screens/library/widgets/playlists_refreshing_widget.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class SongAddToUserPlaylistPage extends StatefulWidget {
  const SongAddToUserPlaylistPage({
    Key? key,
    required this.song,
    required this.onCreateWithSongSuccess,
  }) : super(key: key);

  final Song song;
  final Function(MyPlaylist) onCreateWithSongSuccess;

  @override
  _SongAddToUserPlaylistPageState createState() => _SongAddToUserPlaylistPageState();
}

class _SongAddToUserPlaylistPageState extends State<SongAddToUserPlaylistPage> {
  @override
  void initState() {
    BlocProvider.of<MyPlaylistBloc>(context).add(
      LoadAllMyPlaylistsEvent(isForAddSongPage: true),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserPlaylistBloc, UserPlaylistState>(
      listener: (context, state) {
        ///REQUEST SUCCESS MESSAGE
        if (state is SongAddedToPlaylistState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.white,
              isFloating: true,
              msg:
                  "${L10nUtil.translateLocale(state.song.songName, context)} added to ${L10nUtil.translateLocale(state.myPlaylist.playlistNameText, context)}",
              txtColor: AppColors.black,
              icon: PhosphorIcons.check_circle_fill,
              iconColor: AppColors.darkGreen,
            ),
          );

          ///CALL TO LOAD ALL MY PLAYLISTS
          BlocProvider.of<MyPlaylistBloc>(context).add(
            LoadAllMyPlaylistsEvent(
              isForAddSongPage: false,
            ),
          );
          Navigator.pop(context);
        }

        ///REQUEST FAILURE MESSAGE
        if (state is UserPlaylistLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg: "Unable add mezmur to playlist\ncheck your internet connection",
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
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildHeaderAndList(context),
            buildPageLoading(),
            buildPlaylistsRefreshing(),
          ],
        ),
      ),
    );
  }

  Container buildHeaderAndList(mContext) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTopItems(mContext),
          buildPlaylistsList(),
        ],
      ),
    );
  }

  BlocBuilder<MyPlaylistBloc, MyPlaylistState> buildPlaylistsRefreshing() {
    return BlocBuilder<MyPlaylistBloc, MyPlaylistState>(
      builder: (context, state) {
        if (state is MyPlaylistRefreshLoadingState) {
          return PlaylistsRefreshingWidget();
        }
        return SizedBox();
      },
    );
  }

  Expanded buildPlaylistsList() {
    return Expanded(
      child: BlocBuilder<MyPlaylistBloc, MyPlaylistState>(
        builder: (context, state) {
          if (state is MyPlaylistLoadingState) {
            return AppLoading(size: AppValues.loadingWidgetSize);
          } else if (state is MyPlaylistPageDataLoaded) {
            if (state.myPlaylistPageData.myPlaylists.length > 0) {
              return ListView.separated(
                itemCount: state.myPlaylistPageData.myPlaylists.length,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(height: AppMargin.margin_16);
                },
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      index == 0
                          ? Padding(
                              padding: EdgeInsets.only(
                                bottom: AppPadding.padding_16,
                              ),
                              child: Text(
                                "Add to existing playlists",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.txtGrey,
                                  fontSize: AppFontSizes.font_size_8.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : SizedBox(),
                      LibraryMyPlaylistItem(
                        myPlaylist: state.myPlaylistPageData.myPlaylists.elementAt(index),
                        onTap: () {
                          BlocProvider.of<UserPlaylistBloc>(context).add(
                            AddSongUserPlaylistEvent(
                              myPlaylist: state.myPlaylistPageData.myPlaylists.elementAt(index),
                              song: widget.song,
                            ),
                          );
                        },
                        isForSongAddToPlaylistPage: true,
                      ),
                    ],
                  );
                },
              );
            } else {
              return LibraryEmptyPage(
                icon: PhosphorIcons.playlist_light,
                msg: "You haven't created any playlists press new playlist to start adding.",
              );
            }
          } else if (state is MyPlaylistLoadingErrorState) {
            return AppError(
              onRetry: () {
                BlocProvider.of<MyPlaylistBloc>(context).add(
                  LoadAllMyPlaylistsEvent(isForAddSongPage: true),
                );
              },
              bgWidget: AppLoading(size: AppValues.loadingWidgetSize),
            );
          }
          return AppLoading(size: AppValues.loadingWidgetSize);
        },
      ),
    );
  }

  BlocBuilder<UserPlaylistBloc, UserPlaylistState> buildPageLoading() {
    return BlocBuilder<UserPlaylistBloc, UserPlaylistState>(
      builder: (context, state) {
        if (state is UserPlaylistLoadingState) {
          return buildPostingPlaylistLoading();
        }
        return SizedBox();
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      backgroundColor: AppColors.black,
      shadowColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(PhosphorIcons.caret_left_light),
        color: AppColors.white,
        iconSize: AppIconSizes.icon_size_24,
      ),
      centerTitle: true,
      title: Text(
        "Add to playlist",
        style: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Container buildPostingPlaylistLoading() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.completelyBlack.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_32,
      ),
      child: AppLoading(
        size: AppValues.loadingWidgetSize * 0.5,
      ),
    );
  }

  buildTopItems(mContext) {
    return Column(
      children: [
        SizedBox(
          height: AppMargin.margin_32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBouncingButton(
              onTap: () {
                PagesUtilFunctions.openCreatePlaylistPageForAdding(
                  mContext,
                  widget.song,
                  widget.onCreateWithSongSuccess,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_32,
                  vertical: AppPadding.padding_8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "New playlist".toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Text(
          "Add to newly created playlist",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.txtGrey,
            fontSize: AppFontSizes.font_size_8.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Divider(
          color: AppColors.darkGrey,
          height: 1,
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
      ],
    );
  }
}
