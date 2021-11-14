import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_albums_bloc/purchased_albums_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/library_data/purchased_album.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/screens/library/widgets/auto_download.dart';
import 'package:elf_play/ui/screens/library/widgets/library_album_item.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_error_widget.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class PurchasedAlbumsPage extends StatefulWidget {
  const PurchasedAlbumsPage({Key? key, required this.onAlbumsLoaded})
      : super(key: key);

  final Function(List<Album>) onAlbumsLoaded;

  @override
  _PurchasedAlbumsPageState createState() => _PurchasedAlbumsPageState();
}

class _PurchasedAlbumsPageState extends State<PurchasedAlbumsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL PURCHASED AlbumS
    BlocProvider.of<PurchasedAlbumsBloc>(context)
        .add(LoadPurchasedAlbumsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = ScreenUtil(context: context).getScreenHeight();
    return BlocBuilder<PurchasedAlbumsBloc, PurchasedAlbumsState>(
      builder: (context, state) {
        if (state is PurchasedAlbumsLoadingState) {
          return buildAppLoading(context, screenHeight);
        } else if (state is PurchasedAlbumsLoadedState) {
          ///PASS ALL LOADED ALBUMS TO PREVIOUS PAGE
          widget.onAlbumsLoaded(
            state.purchasedAlbums.map((e) => e.album).toList(),
          );
          if (state.purchasedAlbums.length > 0) {
            return buildPageLoaded(state.purchasedAlbums);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.disc_fill,
                msg: AppLocale.of().uDontHavePurchasedAlbums,
              ),
            );
          }
        } else if (state is PurchasedAlbumsLoadingErrorState) {
          return Container(
            height: ScreenUtil(context: context).getScreenHeight() * 0.5,
            child: LibraryErrorWidget(
              onRetry: () {
                BlocProvider.of<PurchasedAlbumsBloc>(context)
                    .add(LoadPurchasedAlbumsEvent());
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

  Widget buildPageLoaded(List<PurchasedAlbum> purchasedAlbums) {
    return Column(
      children: [
        AutoDownloadRadio(downloadAllSelected: true),
        SizedBox(height: AppMargin.margin_8),
        buildAlbumList(purchasedAlbums)
      ],
    );
  }

  ListView buildAlbumList(List<PurchasedAlbum> purchasedAlbum) {
    return ListView.builder(
      itemCount: purchasedAlbum.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return LibraryAlbumItem(
          position: position,
          album: purchasedAlbum[position].album,
        );
      },
    );
  }
}
