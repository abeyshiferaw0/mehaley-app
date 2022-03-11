import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/my_playlist_bloc/my_playlist_bloc.dart';
import 'package:mehaley/business_logic/cubits/library/following_tab_pages_cubit.dart';
import 'package:mehaley/business_logic/cubits/library/library_tab_pages_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/screens/library/tab_pages/tab_pages/my_playlists_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_icon_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';

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
          color: ColorMapper.getDarkOrange(),
          edgeOffset: AppMargin.margin_16,
          child: Container(
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
                  text: AppLocale.of().myPlaylists.toUpperCase(),
                  isSelected: true,
                  onTap: () {},
                  hasLeftMargin: false,
                ),
                LibraryPageSubTabButton(
                  text: AppLocale.of().following.toUpperCase(),
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
          iconColor: ColorMapper.getBlack(),
          icon: FlutterRemix.add_line,
        )
      ],
    );
  }
}
