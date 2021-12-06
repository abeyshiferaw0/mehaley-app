import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';

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
            child: Padding(
              padding: EdgeInsets.all(AppPadding.padding_8),
              child: preCartIcon(),
            ),
          );
        },
      );
    }
  }

  void onTap() {
    ///LIKE UNLIKE ALBUM
    EasyDebounce.debounce(
      'ALBUM_LIKE',
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
          FlutterRemix.shopping_cart_2_line,
          size: AppIconSizes.icon_size_24,
          color: AppColors.darkOrange,
        );
      } else {
        return Icon(
          FlutterRemix.shopping_cart_2_line,
          size: AppIconSizes.icon_size_24,
          color: AppColors.black,
        );
      }
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedAlbumBox
        .containsKey(widget.album.albumId)) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_24,
        color: AppColors.darkOrange,
      );
    }

    ///IF ALBUM IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedAlbumBox
        .containsKey(widget.album.albumId)) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_24,
        color: AppColors.black,
      );
    }

    ///IF ALBUM IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.album.isInCart) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_24,
        color: AppColors.darkOrange,
      );
    } else {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_24,
        color: AppColors.black,
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
