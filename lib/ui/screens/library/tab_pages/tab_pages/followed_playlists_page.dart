import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/followed_playlist_bloc/followed_playlists_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/library_data/followed_playlist.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_error_widget.dart';
import 'package:mehaley/ui/screens/library/widgets/library_playlist_item.dart';
import 'package:mehaley/util/screen_util.dart';

class FollowedPlaylistsPage extends StatefulWidget {
  const FollowedPlaylistsPage({Key? key}) : super(key: key);

  @override
  _FollowedPlaylistsPageState createState() => _FollowedPlaylistsPageState();
}

class _FollowedPlaylistsPageState extends State<FollowedPlaylistsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL FAVORITE ALBUMS
    BlocProvider.of<FollowedPlaylistsBloc>(context).add(
      LoadFollowedPlaylistsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<FollowedPlaylistsBloc, FollowedPlaylistsState>(
      builder: (context, state) {
        if (state is FollowedPlaylistsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is FollowedPlaylistsLoadedState) {
          if (state.followedPlaylists.length > 0) {
            return buildPageLoaded(state.followedPlaylists);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: FlutterRemix.add_box_fill,
                msg: AppLocale.of().uAreNotFollowingPlaylist,
              ),
            );
          }
        } else if (state is FollowedPlaylistsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<FollowedPlaylistsBloc>(context).add(
                  LoadFollowedPlaylistsEvent(),
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

  Widget buildPageLoaded(List<FollowedPlaylist> followedPlaylists) {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_8),
        buildPlaylistList(followedPlaylists)
      ],
    );
  }

  Padding buildPlaylistList(List<FollowedPlaylist> purchasedPlaylist) {
    return Padding(
      padding: EdgeInsets.only(right: AppPadding.padding_16),
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemCount: purchasedPlaylist.length,
        itemBuilder: (BuildContext context, int index) {
          return LibraryPlaylistItem(
            playlist: purchasedPlaylist[index].playlist,
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (1 / 1.3),
          crossAxisSpacing: AppMargin.margin_12,
          mainAxisSpacing: AppMargin.margin_16,
          crossAxisCount: 2,
        ),
      ),
    );
  }
}
