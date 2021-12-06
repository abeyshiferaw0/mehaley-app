import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/cart/playlist_cart.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/dialog/dialog_remove_from_cart.dart';
import 'package:mehaley/ui/screens/cart/widgets/item_cart_playlist.dart';

import 'card_header_title.dart';

class CartPlaylistsList extends StatefulWidget {
  const CartPlaylistsList({Key? key, required this.playlistCart})
      : super(key: key);

  final PlaylistCart playlistCart;

  @override
  _CartPlaylistsListState createState() => _CartPlaylistsListState(
        playlistCart: playlistCart,
      );
}

class _CartPlaylistsListState extends State<CartPlaylistsList> {
  final PlaylistCart playlistCart;

  _CartPlaylistsListState({required this.playlistCart});

  @override
  Widget build(BuildContext context) {
    if (playlistCart.items.length > 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CartHeaderTitle(
              title: AppLocale.of().playlists,
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildCartPlaylists(playlistCart.items),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildCartPlaylists(List<Playlist> playlists) {
    final items = <Widget>[];

    if (playlists.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < playlists.length; i++) {
        items.add(
          CartPlaylistItem(
            playlist: playlists[i],
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
                          AddRemovePlaylistCartEvent(
                            playlist: playlists[i],
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
