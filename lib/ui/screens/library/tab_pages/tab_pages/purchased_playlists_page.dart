import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/library_page_bloc/purchased_playlist_bloc/purchased_playlist_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/library_data/purchased_playlist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/library/widgets/auto_download.dart';
import 'package:mehaley/ui/screens/library/widgets/library_empty_page.dart';
import 'package:mehaley/ui/screens/library/widgets/library_error_widget.dart';
import 'package:mehaley/ui/screens/library/widgets/library_playlist_item.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class PurchasedPlaylistsPage extends StatefulWidget {
  const PurchasedPlaylistsPage({Key? key, required this.onPlaylistsLoaded})
      : super(key: key);

  final Function(List<Playlist>) onPlaylistsLoaded;

  @override
  _PurchasedPlaylistsPageState createState() => _PurchasedPlaylistsPageState();
}

class _PurchasedPlaylistsPageState extends State<PurchasedPlaylistsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL PURCHASED PlaylistS
    BlocProvider.of<PurchasedPlaylistBloc>(context)
        .add(LoadPurchasedPlaylistsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<PurchasedPlaylistBloc, PurchasedPlaylistState>(
      builder: (context, state) {
        if (state is PurchasedPlaylistsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is PurchasedPlaylistsLoadedState) {
          ///PASS ALL LOADED PLAYLISTS TO PREVIOUS PAGE
          widget.onPlaylistsLoaded(
            state.purchasedPlaylists.map((e) => e.playlist).toList(),
          );
          if (state.purchasedPlaylists.length > 0) {
            return buildPageLoaded(state.purchasedPlaylists);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.playlist_fill,
                msg: AppLocale.of().uDontHavePurchasedPlaylists,
              ),
            );
          }
        } else if (state is PurchasedPlaylistsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<PurchasedPlaylistBloc>(context)
                    .add(LoadPurchasedPlaylistsEvent());
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

  Widget buildPageLoaded(List<PurchasedPlaylist> purchasedPlaylists) {
    return Column(
      children: [
        AutoDownloadRadio(downloadAllSelected: true),
        SizedBox(height: AppMargin.margin_8),
        buildPlaylistList(purchasedPlaylists)
      ],
    );
  }

  Padding buildPlaylistList(List<PurchasedPlaylist> purchasedPlaylist) {
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
