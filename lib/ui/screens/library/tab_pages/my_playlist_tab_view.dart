import 'package:elf_play/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:elf_play/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:elf_play/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/my_playlists_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_icon_button.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../widgets/library_sub_tab_button.dart';

class MyPlaylistTabView extends StatefulWidget {
  const MyPlaylistTabView({Key? key, required this.onGoToFollowedPlaylist})
      : super(key: key);

  final VoidCallback onGoToFollowedPlaylist;

  @override
  _MyPlaylistTabViewState createState() => _MyPlaylistTabViewState();
}

class _MyPlaylistTabViewState extends State<MyPlaylistTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
      builder: (context) {
        return RefreshIndicator(
          onRefresh: () async {
            if (BlocProvider.of<LibraryTabPagesCubit>(context).state == 2) {
              BlocProvider.of<MyPlaylistBloc>(context).add(
                RefreshMyPlaylistEvent(
                  isForAddSongPage: false,
                  now: DateTime.now(),
                ),
              );
              await BlocProvider.of<MyPlaylistBloc>(context).stream.first;
              return;
            }
          },
          color: AppColors.darkGreen,
          edgeOffset: AppMargin.margin_16,
          child: Container(
            color: AppColors.black,
            height: ScreenUtil(context: context).getScreenHeight(),
            padding: EdgeInsets.only(left: AppPadding.padding_16),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: AppMargin.margin_8),
                  buildSubTabs(),
                  SizedBox(height: AppMargin.margin_8),
                  MyPlaylistsPage(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row buildSubTabs() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LibraryPageSubTabButton(
                  text: "MY PLAYLISTS",
                  isSelected: true,
                  onTap: () {},
                  hasLeftMargin: false,
                ),
                LibraryPageSubTabButton(
                  text: "FOLLOWING",
                  isSelected: false,
                  onTap: () {
                    widget.onGoToFollowedPlaylist();
                    BlocProvider.of<FollowingTabPagesCubit>(context).changePage(
                      AppFollowedPageItemTypes.PLAYLISTS,
                    );
                  },
                  hasLeftMargin: true,
                ),
              ],
            ),
          ),
        ),
        LibraryIconButton(
          onTap: () {
            PagesUtilFunctions.openCreatePlaylistPage(context);
          },
          iconColor: AppColors.white,
          icon: PhosphorIcons.plus_light,
        )
      ],
    );
  }
}
