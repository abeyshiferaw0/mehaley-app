import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class AlbumCartButton extends StatefulWidget {
  const AlbumCartButton({
    Key? key,
    required this.album,
  }) : super(key: key);

  final Album album;

  @override
  _AlbumCartButtonState createState() => _AlbumCartButtonState();
}

class _AlbumCartButtonState extends State<AlbumCartButton> {
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
          return AppBouncingButton(
            onTap: onTap,
            child: preCartIcon(),
          );
        },
      );
    }
  }

  void onTap() {
    ///LIKE UNLIKE ALBUM
    EasyDebounce.debounce(
      'ALBUM_LIKE',
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

  Icon preCartIcon() {
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
        return Icon(
          PhosphorIcons.shopping_cart_simple_fill,
          size: AppIconSizes.icon_size_24,
          color: AppColors.darkGreen,
        );
      } else {
        return Icon(
          PhosphorIcons.shopping_cart_simple_light,
          size: AppIconSizes.icon_size_24,
          color: AppColors.white,
        );
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return Icon(
        PhosphorIcons.shopping_cart_simple_fill,
        size: AppIconSizes.icon_size_24,
        color: AppColors.darkGreen,
      );
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return Icon(
        PhosphorIcons.shopping_cart_simple_light,
        size: AppIconSizes.icon_size_24,
        color: AppColors.white,
      );
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return Icon(
        PhosphorIcons.shopping_cart_simple_fill,
        size: AppIconSizes.icon_size_24,
        color: AppColors.darkGreen,
      );
    } else {
      return Icon(
        PhosphorIcons.shopping_cart_simple_light,
        size: AppIconSizes.icon_size_24,
        color: AppColors.white,
      );
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
