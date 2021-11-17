import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/followed_artist_bloc/followed_artists_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/library_data/followed_artist.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/library/widgets/library_artist_item.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_error_widget.dart';
import 'package:mehaley/util/screen_util.dart';

class FollowedArtistsPage extends StatefulWidget {
  const FollowedArtistsPage({Key? key}) : super(key: key);

  @override
  _FollowedArtistsPageState createState() => _FollowedArtistsPageState();
}

class _FollowedArtistsPageState extends State<FollowedArtistsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL FAVORITE ALBUMS
    BlocProvider.of<FollowedArtistsBloc>(context).add(
      LoadFollowedArtistsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<FollowedArtistsBloc, FollowedArtistsState>(
      builder: (context, state) {
        if (state is FollowedArtistsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is FollowedArtistsLoadedState) {
          if (state.followedArtists.length > 0) {
            return buildPageLoaded(state.followedArtists);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: FlutterRemix.add_box_fill,
                msg: AppLocale.of().uAreNotFollowingArtist,
              ),
            );
          }
        } else if (state is FollowedArtistsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<FollowedArtistsBloc>(context).add(
                  LoadFollowedArtistsEvent(),
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

  Widget buildPageLoaded(List<FollowedArtist> followedArtists) {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_8),
        buildArtistList(followedArtists)
      ],
    );
  }

  ListView buildArtistList(List<FollowedArtist> followedArtists) {
    return ListView.separated(
      itemCount: followedArtists.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return LibraryArtistsItem(
          artist: followedArtists.elementAt(position).artist,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: AppMargin.margin_24,
        );
      },
    );
  }
}
