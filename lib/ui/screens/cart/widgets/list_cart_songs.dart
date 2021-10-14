import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/cart/song_cart.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/dialog/dialog_remove_from_cart.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'card_header_title.dart';

class CartSongsList extends StatefulWidget {
  const CartSongsList({Key? key, required this.songCart}) : super(key: key);

  final SongCart songCart;

  @override
  _CartSongsListState createState() => _CartSongsListState(
        songCart: songCart,
      );
}

class _CartSongsListState extends State<CartSongsList> {
  final SongCart songCart;

  _CartSongsListState({required this.songCart});

  @override
  Widget build(BuildContext context) {
    if (songCart.items.length > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartHeaderTitle(
            title: 'Mezmurs',
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
            ),
            child: ListView.builder(
              itemCount: songCart.items.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    SongItem(
                      song: songCart.items.elementAt(index),
                      isForMyPlaylist: false,
                      isForCart: true,
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
                                    RemoveSongFromCartEvent(
                                      song: songCart.items.elementAt(index),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      position: (index + 1),
                      thumbUrl: AppApi.baseFileUrl +
                          songCart.items
                              .elementAt(index)
                              .albumArt
                              .imageSmallPath,
                      thumbSize: AppValues.categorySongItemSize,
                      onPressed: () {
                        //OPEN SONG
                        PagesUtilFunctions.openSong(
                          context: context,
                          songs: [songCart.items.elementAt(index)],
                          playingFrom: PlayingFrom(
                            from: "playing from cart",
                            title: "mezmurs",
                            songSyncPlayedFrom: SongSyncPlayedFrom.CART_PAGE,
                            songSyncPlayedFromId: -1,
                          ),
                          startPlaying: true,
                          index: 0,
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_8),
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
