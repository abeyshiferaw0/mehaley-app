import 'package:elf_play/business_logic/blocs/library_page_bloc/purchased_albums_bloc/purchased_albums_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/library_data/purchased_album.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/screens/library/widgets/auto_download.dart';
import 'package:elf_play/ui/screens/library/widgets/library_album_item.dart';
import 'package:elf_play/ui/screens/library/widgets/library_empty_page.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class PurchasedAlbumsPage extends StatefulWidget {
  const PurchasedAlbumsPage({Key? key}) : super(key: key);

  @override
  _PurchasedAlbumsPageState createState() => _PurchasedAlbumsPageState();
}

class _PurchasedAlbumsPageState extends State<PurchasedAlbumsPage> {
  @override
  void initState() {
    ///INITIALLY LOAD ALL PURCHASED AlbumS
    BlocProvider.of<PurchasedAlbumsBloc>(context).add(
      LoadPurchasedAlbumsEvent(),
    );
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
          if (state.purchasedAlbums.length > 0) {
            return buildPageLoaded(state.purchasedAlbums);
          } else {
            return Container(
              height: screenHeight * 0.5,
              child: LibraryEmptyPage(
                icon: PhosphorIcons.folder_fill,
                msg: "You don't have any purchased\nalbums",
              ),
            );
          }
        } else if (state is PurchasedAlbumsLoadingErrorState) {
          return Container(
            height: screenHeight * 0.5,
            child: Text(
              state.error,
              style: TextStyle(
                color: AppColors.errorRed,
              ),
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
      child: AppLoading(size: AppValues.loadingWidgetSize),
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
