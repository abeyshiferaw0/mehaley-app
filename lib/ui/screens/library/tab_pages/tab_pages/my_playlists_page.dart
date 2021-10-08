import 'package:elf_play/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_error_widget.dart';
import 'package:elf_play/ui/screens/library/widgets/library_my_playlist_item.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class MyPlaylistsPage extends StatefulWidget {
  const MyPlaylistsPage({
    Key? key,
  }) : super(key: key);

  @override
  _MyPlaylistItemsListState createState() => _MyPlaylistItemsListState();
}

class _MyPlaylistItemsListState extends State<MyPlaylistsPage> {
  @override
  void initState() {
    BlocProvider.of<MyPlaylistBloc>(context).add(
      LoadAllMyPlaylistsEvent(isForAddSongPage: false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<MyPlaylistBloc, MyPlaylistState>(
      builder: (context, state) {
        if (state is MyPlaylistLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is MyPlaylistPageDataLoaded) {
          if (state.myPlaylistPageData.myPlaylists.length > 0) {
            return buildPageLoaded(state.myPlaylistPageData.myPlaylists);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                emptyMyPlaylist: true,
                icon: PhosphorIcons.plus_circle_fill,
                msg: "You haven't created any playlists",
              ),
            );
          }
        } else if (state is MyPlaylistLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<MyPlaylistBloc>(context).add(
                  LoadAllMyPlaylistsEvent(isForAddSongPage: false),
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

  Widget buildPageLoaded(List<MyPlaylist> myPlaylists) {
    return Column(
      children: [
        buildCreatePlaylistButton(context),
        SizedBox(height: AppMargin.margin_16),
        ListView.separated(
          itemCount: myPlaylists.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return SizedBox(height: AppMargin.margin_16);
          },
          itemBuilder: (context, index) {
            return LibraryMyPlaylistItem(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouterPaths.userPlaylistRoute,
                  arguments: ScreenArguments(
                    args: {
                      'playlistId': myPlaylists.elementAt(index).playlistId
                    },
                  ),
                );
              },
              myPlaylist: myPlaylists.elementAt(index),
              isForSongAddToPlaylistPage: false,
            );
          },
        ),
      ],
    );
  }

  AppBouncingButton buildCreatePlaylistButton(context) {
    return AppBouncingButton(
      onTap: () {
        PagesUtilFunctions.openCreatePlaylistPage(context);
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppCard(
              child: Container(
                width: AppValues.libraryMusicItemSize,
                height: AppValues.libraryMusicItemSize,
                color: AppColors.darkGrey,
                child: Icon(
                  PhosphorIcons.plus_light,
                  color: AppColors.white,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
            SizedBox(width: AppMargin.margin_16),
            Expanded(
              child: Text(
                "Create New playlist",
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
