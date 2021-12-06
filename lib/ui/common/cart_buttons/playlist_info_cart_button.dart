import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class PlaylistInfoCartButton extends StatefulWidget {
  const PlaylistInfoCartButton({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  _PlaylistInfoCartButtonState createState() => _PlaylistInfoCartButtonState();
}

class _PlaylistInfoCartButtonState extends State<PlaylistInfoCartButton> {
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
          return AppBouncingButton(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: AppPadding.padding_2),
                    child: preCartIcon(),
                  ),
                  SizedBox(width: AppMargin.margin_8),
                  Text(
                    preCartText(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.bold,
                      // color: AppColors.darkGrey,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void onTap() {
    ///LIKE UNLIKE PLAYLIST
    EasyDebounce.debounce(
      'PLAYLIST_LIKE',
      Duration(milliseconds: 0),
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

  Icon preCartIcon() {
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
        return Icon(
          FlutterRemix.shopping_cart_2_line,
          size: AppIconSizes.icon_size_20,
          color: AppColors.darkOrange,
        );
      } else {
        return Icon(
          FlutterRemix.shopping_cart_2_line,
          size: AppIconSizes.icon_size_20,
          color: AppColors.darkGrey,
        );
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkOrange,
      );
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkGrey,
      );
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkOrange,
      );
    } else {
      return Icon(
        FlutterRemix.shopping_cart_2_line,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkGrey,
      );
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
        return AppLocale.of().removeFromCart.toUpperCase();
      } else {
        return AppLocale.of().addToCart.toUpperCase();
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return AppLocale.of().removeFromCart.toUpperCase();
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox
        .containsKey(widget.playlist.playlistId)) {
      return AppLocale.of().addToCart.toUpperCase();
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return AppLocale.of().removeFromCart.toUpperCase();
    } else {
      return AppLocale.of().addToCart.toUpperCase();
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
