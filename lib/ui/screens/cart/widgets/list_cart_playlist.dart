import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/cart/playlist_cart.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/ui/common/dialog/dialog_remove_from_cart.dart';
import 'package:elf_play/ui/screens/cart/widgets/item_cart_playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              title: 'Playlists',
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
                      mainButtonText: 'REMOVE'.toUpperCase(),
                      cancelButtonText: 'CANCEL',
                      titleText: 'Remove From Cart?',
                      onRemove: () {
                        BlocProvider.of<CartUtilBloc>(context).add(
                          RemovePlaylistFromCartEvent(playlist: playlists[i]),
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