import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/cart/song_cart.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/dialog/dialog_remove_from_cart.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/util/pages_util_functions.dart';

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
            title: AppLocale.of().mezmurs,
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
                                mainButtonText:
                                    AppLocale.of().remove.toUpperCase(),
                                cancelButtonText:
                                    AppLocale.of().cancel.toUpperCase(),
                                titleText: AppLocale.of().removeFromCart,
                                onRemove: () {
                                  BlocProvider.of<CartUtilBloc>(context).add(
                                    AddRemovedSongCartEvent(
                                      song: songCart.items.elementAt(index),
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
                      position: (index + 1),
                      thumbUrl: AppApi.baseUrl +
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
                            from: AppLocale.of().playingFromCart,
                            title: AppLocale.of().mezmurs,
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
