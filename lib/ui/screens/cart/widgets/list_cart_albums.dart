import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/cart/album_cart.dart';
import 'package:mehaley/ui/common/dialog/dialog_remove_from_cart.dart';
import 'package:mehaley/ui/screens/cart/widgets/item_cart_album.dart';

import 'card_header_title.dart';

class CartAlbumsList extends StatefulWidget {
  const CartAlbumsList({Key? key, required this.albumCart}) : super(key: key);

  final AlbumCart albumCart;

  @override
  _CartAlbumsListState createState() => _CartAlbumsListState(
        albumCart: albumCart,
      );
}

class _CartAlbumsListState extends State<CartAlbumsList> {
  final AlbumCart albumCart;

  _CartAlbumsListState({required this.albumCart});

  @override
  Widget build(BuildContext context) {
    if (albumCart.items.length > 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CartHeaderTitle(
              title: AppLocale.of().albums,
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildCartAlbums(albumCart.items),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildCartAlbums(List<Album> albums) {
    final items = <Widget>[];

    if (albums.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < albums.length; i++) {
        items.add(
          CartAlbumItem(
            album: albums[i],
            onRemoveFromCart: () {
              showDialog(
                context: context,
                builder: (_) {
                  return Center(
                    child: DialogRemoveFromCart(
                      mainButtonText: AppLocale.of().remove.toUpperCase(),
                      cancelButtonText: AppLocale.of().cancel.toUpperCase(),
                      titleText: AppLocale.of().removeFromCart,
                      onRemove: () {
                        BlocProvider.of<CartUtilBloc>(context).add(
                          AddRemoveAlbumCartEvent(
                            album: albums[i],
                            appCartAddRemoveEvents:
                                AppCartAddRemoveEvents.REMOVE,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }
}
