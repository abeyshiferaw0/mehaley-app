import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/playlist.dart';

import 'menu_item.dart';

class PlaylistCartMenuItem extends StatefulWidget {
  const PlaylistCartMenuItem({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  _PlaylistCartMenuItemState createState() => _PlaylistCartMenuItemState();
}

class _PlaylistCartMenuItemState extends State<PlaylistCartMenuItem> {
  @override
  @override
  Widget build(BuildContext context) {
    if (widget.playlist.isBought || widget.playlist.isFree) {
      return SizedBox();
    } else {
      return BlocBuilder<CartUtilBloc, CartUtilState>(
        buildWhen: (previousState, currentState) {
          if (currentState is CartUtilPlaylistAddingState ||
              currentState is CartUtilPlaylistAddedSuccessState ||
              currentState is CartUtilPlaylistAddingErrorState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return MenuItem(
            isDisabled: false,
            hasTopMargin: true,
            iconColor: preCartIconColor(),
            icon: preCartIcon(),
            title: preCartText(),
            onTap: () {
              onTap();
            },
          );
        },
      );
    }
  }

  void onTap() {
    ///ADD REMOVE PLAYLIST
    EasyDebounce.debounce(
      'PLAYLIST_CART_ADD_REMOVE',
      Duration(milliseconds: 800),
      () {
        BlocProvider.of<CartUtilBloc>(context).add(
          AddRemovePlaylistCartEvent(
            playlist: widget.playlist,
            appCartAddRemoveEvents: preButtonOnTap()
                ? AppCartAddRemoveEvents.REMOVE
                : AppCartAddRemoveEvents.ADD,
          ),
        );
      },
    );
  }

  IconData preCartIcon() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
            .containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
            .containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
          .get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
          .get(widget.playlist.playlistId);
      if (a > b) {
        return PhosphorIcons.shopping_cart_simple_fill;
      } else {
        return PhosphorIcons.shopping_cart_simple_light;
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return PhosphorIcons.shopping_cart_simple_fill;
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return PhosphorIcons.shopping_cart_simple_light;
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return PhosphorIcons.shopping_cart_simple_fill;
    } else {
      return PhosphorIcons.shopping_cart_simple_light;
    }
  }

  Color preCartIconColor() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
            .containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
            .containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
          .get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
          .get(widget.playlist.playlistId);
      if (a > b) {
        return AppColors.darkOrange;
      } else {
        return AppColors.grey.withOpacity(0.6);
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return AppColors.darkOrange;
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return AppColors.grey.withOpacity(0.6);
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return AppColors.darkOrange;
    } else {
      return AppColors.grey.withOpacity(0.6);
    }
  }

  String preCartText() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
            .containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
            .containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
          .get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
          .get(widget.playlist.playlistId);
      if (a > b) {
        return AppLocale.of().removeFromCart;
      } else {
        return AppLocale.of().addToCart;
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return AppLocale.of().removeFromCart;
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return AppLocale.of().addToCart;
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return AppLocale.of().removeFromCart;
    } else {
      return AppLocale.of().addToCart;
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
            .containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
            .containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
          .get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
          .get(widget.playlist.playlistId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return true;
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return false;
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    return widget.playlist.isInCart;
  }
}
