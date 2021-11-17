import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';

import 'menu_item.dart';

class AlbumCartMenuItem extends StatefulWidget {
  const AlbumCartMenuItem({
    Key? key,
    required this.album,
  }) : super(key: key);

  final Album album;

  @override
  _AlbumCartMenuItemState createState() => _AlbumCartMenuItemState();
}

class _AlbumCartMenuItemState extends State<AlbumCartMenuItem> {
  @override
  @override
  Widget build(BuildContext context) {
    if (widget.album.isBought || widget.album.isFree) {
      return SizedBox();
    } else {
      return BlocBuilder<CartUtilBloc, CartUtilState>(
        buildWhen: (previousState, currentState) {
          if (currentState is CartUtilAlbumAddingState ||
              currentState is CartUtilAlbumAddedSuccessState ||
              currentState is CartUtilAlbumAddingErrorState) {
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
    ///ADD REMOVE ALBUM
    EasyDebounce.debounce(
      'ALBUM_CART_ADD_REMOVE',
      Duration(milliseconds: 0),
      () {
        BlocProvider.of<CartUtilBloc>(context).add(
          AddRemoveAlbumCartEvent(
            album: widget.album,
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
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
            .containsKey(widget.album.albumId) &&
        AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
            .containsKey(widget.album.albumId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedAlbumBox
          .get(widget.album.albumId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
          .get(widget.album.albumId);
      if (a > b) {
        return FlutterRemix.shopping_cart_2_line;
      } else {
        return FlutterRemix.shopping_cart_2_fill;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return FlutterRemix.shopping_cart_2_fill;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return FlutterRemix.shopping_cart_2_line;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return FlutterRemix.shopping_cart_2_fill;
    } else {
      return FlutterRemix.shopping_cart_2_line;
    }
  }

  Color preCartIconColor() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
            .containsKey(widget.album.albumId) &&
        AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
            .containsKey(widget.album.albumId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedAlbumBox
          .get(widget.album.albumId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
          .get(widget.album.albumId);
      if (a > b) {
        return AppColors.darkOrange;
      } else {
        return AppColors.grey.withOpacity(0.6);
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppColors.darkOrange;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppColors.grey.withOpacity(0.6);
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return AppColors.darkOrange;
    } else {
      return AppColors.grey.withOpacity(0.6);
    }
  }

  String preCartText() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
            .containsKey(widget.album.albumId) &&
        AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
            .containsKey(widget.album.albumId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedAlbumBox
          .get(widget.album.albumId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
          .get(widget.album.albumId);
      if (a > b) {
        return AppLocale.of().removeFromCart;
      } else {
        return AppLocale.of().addToCart;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppLocale.of().removeFromCart;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppLocale.of().addToCart;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return AppLocale.of().removeFromCart;
    } else {
      return AppLocale.of().addToCart;
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
            .containsKey(widget.album.albumId) &&
        AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
            .containsKey(widget.album.albumId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedAlbumBox
          .get(widget.album.albumId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
          .get(widget.album.albumId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return true;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return false;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    return widget.album.isInCart;
  }
}
