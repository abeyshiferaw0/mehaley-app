import 'package:elf_play/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:elf_play/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:elf_play/business_logic/cubits/image_picker_cubit.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_my_playlist_item.dart';
import 'package:elf_play/ui/screens/library/widgets/playlists_refreshing_widget.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'create_playlist_page.dart';

class SongAddToPlaylistPage extends StatefulWidget {
  const SongAddToPlaylistPage({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  _SongAddToPlaylistPageState createState() => _SongAddToPlaylistPageState();
}

class _SongAddToPlaylistPageState extends State<SongAddToPlaylistPage> {
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
                    "${state.song.songName.textAm} added to ${state.myPlaylist.playlistNameText.textAm}",
                txtColor: AppColors.black,
                icon: PhosphorIcons.check_circle_fill,
                iconColor: AppColors.darkGreen),
          );
          Navigator.pop(context);
        }

        ///REQUEST FAILURE MESSAGE
        if (state is UserPlaylistLoadingErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              txtColor: AppColors.errorRed,
              msg:
                  "Unable add mezmur to playlist\ncheck your internet connection",
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
            buildHeaderAndList(),
            buildPageLoading(),
            buildPlaylistsRefreshing(),
          ],
        ),
      ),
    );
  }

  Container buildHeaderAndList() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTopItems(),
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
                        myPlaylist: state.myPlaylistPageData.myPlaylists
                            .elementAt(index),
                        onTap: () {
                          BlocProvider.of<UserPlaylistBloc>(context).add(
                            AddSongUserPlaylistEvent(
                              myPlaylist: state.myPlaylistPageData.myPlaylists
                                  .elementAt(index),
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
                msg:
                    "You haven't created any playlists press new playlist to start adding.",
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
      brightness: Brightness.dark,
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

  buildTopItems() {
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
                openCreatePlaylistPage();
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

  void openCreatePlaylistPage() {
    Navigator.of(context, rootNavigator: true).push(
      PagesUtilFunctions.createBottomToUpAnimatedRoute(
        page: MultiBlocProvider(
          providers: [
            BlocProvider<ImagePickerCubit>(
              create: (context) => ImagePickerCubit(
                picker: ImagePicker(),
              ),
            ),
            BlocProvider(
              create: (context) => UserPlaylistBloc(
                userPLayListRepository: AppRepositories.userPLayListRepository,
              ),
            ),
          ],
          child: CreatePlaylistPage(
            createWithSong: true,
            song: widget.song,
          ),
        ),
      ),
    );
  }
}
