import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

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
      "ALBUM_CART_ADD_REMOVE",
      Duration(milliseconds: 800),
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
        return PhosphorIcons.shopping_cart_simple_fill;
      } else {
        return PhosphorIcons.shopping_cart_simple_light;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return PhosphorIcons.shopping_cart_simple_fill;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return PhosphorIcons.shopping_cart_simple_light;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return PhosphorIcons.shopping_cart_simple_fill;
    } else {
      return PhosphorIcons.shopping_cart_simple_light;
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
        return AppColors.darkGreen;
      } else {
        return AppColors.grey.withOpacity(0.6);
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppColors.darkGreen;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppColors.grey.withOpacity(0.6);
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return AppColors.darkGreen;
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
        return AppLocalizations.of(context)!.removeFromCart;
      } else {
        return AppLocalizations.of(context)!.addToCart;
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppLocalizations.of(context)!.removeFromCart;
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return AppLocalizations.of(context)!.addToCart;
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return AppLocalizations.of(context)!.removeFromCart;
    } else {
      return AppLocalizations.of(context)!.addToCart;
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
