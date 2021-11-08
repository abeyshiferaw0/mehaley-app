import 'package:elf_play/business_logic/blocs/library_page_bloc/favorite_album_bloc/favorite_albums_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/library_data/favorite_album.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/screens/library/widgets/library_album_item.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_error_widget.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class FavoriteAlbumsPage extends StatefulWidget {
  const FavoriteAlbumsPage({Key? key, required this.onAlbumsLoaded})
      : super(key: key);

  final Function(List<Album>) onAlbumsLoaded;

  @override
  _FavoriteAlbumsPageState createState() => _FavoriteAlbumsPageState();
}

class _FavoriteAlbumsPageState extends State<FavoriteAlbumsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL FAVORITE ALBUMS
    BlocProvider.of<FavoriteAlbumsBloc>(context).add(
      LoadFavoriteAlbumsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<FavoriteAlbumsBloc, FavoriteAlbumsState>(
      builder: (context, state) {
        if (state is FavoriteAlbumsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is FavoriteAlbumsLoadedState) {
          ///PASS ALL LOADED ALBUMS TO PREVIOUS PAGE
          widget.onAlbumsLoaded(
            state.favoriteAlbums.map((e) => e.album).toList(),
          );
          if (state.favoriteAlbums.length > 0) {
            return buildPageLoaded(state.favoriteAlbums);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.heart_straight_fill,
                msg: AppLocalizations.of(context)!.uDontHaveFavAlbums,
              ),
            );
          }
        } else if (state is FavoriteAlbumsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<FavoriteAlbumsBloc>(context).add(
                  LoadFavoriteAlbumsEvent(),
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

  Widget buildPageLoaded(List<FavoriteAlbum> favoriteAlbums) {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_8),
        buildAlbumList(favoriteAlbums)
      ],
    );
  }

  ListView buildAlbumList(List<FavoriteAlbum> favoriteAlbums) {
    return ListView.builder(
      itemCount: favoriteAlbums.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return LibraryAlbumItem(
          position: position,
          album: favoriteAlbums[position].album,
        );
      },
    );
  }
}
