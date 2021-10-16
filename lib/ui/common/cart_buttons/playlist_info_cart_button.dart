import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

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
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
                vertical: AppPadding.padding_8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: AppColors.lightGrey,
              ),
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
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_14,
                      fontWeight: FontWeight.bold,
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
      "PLAYLIST_LIKE",
      Duration(milliseconds: 800),
      () {
        BlocProvider.of<CartUtilBloc>(context).add(
          AddRemovePlaylistCartEvent(
            playlist: widget.playlist,
            appCartAddRemoveEvents: preButtonOnTap() ? AppCartAddRemoveEvents.REMOVE : AppCartAddRemoveEvents.ADD,
          ),
        );
      },
    );
  }

  Icon preCartIcon() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.get(widget.playlist.playlistId);
      if (a > b) {
        return Icon(
          PhosphorIcons.shopping_cart_simple_fill,
          size: AppIconSizes.icon_size_20,
          color: AppColors.darkGreen,
        );
      } else {
        return Icon(
          PhosphorIcons.shopping_cart_simple_light,
          size: AppIconSizes.icon_size_20,
          color: AppColors.black,
        );
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      return Icon(
        PhosphorIcons.shopping_cart_simple_fill,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkGreen,
      );
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      return Icon(
        PhosphorIcons.shopping_cart_simple_light,
        size: AppIconSizes.icon_size_20,
        color: AppColors.black,
      );
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return Icon(
        PhosphorIcons.shopping_cart_simple_fill,
        size: AppIconSizes.icon_size_20,
        color: AppColors.darkGreen,
      );
    } else {
      return Icon(
        PhosphorIcons.shopping_cart_simple_light,
        size: AppIconSizes.icon_size_20,
        color: AppColors.black,
      );
    }
  }

  String preCartText() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.get(widget.playlist.playlistId);
      if (a > b) {
        return "REMOVE FROM CART".toUpperCase();
      } else {
        return "ADD TO CART".toUpperCase();
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      return "REMOVE FROM CART".toUpperCase();
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      return "ADD TO CART".toUpperCase();
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.playlist.isInCart) {
      return "REMOVE FROM CART".toUpperCase();
    } else {
      return "ADD TO CART".toUpperCase();
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.containsKey(widget.playlist.playlistId) &&
        AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.get(widget.playlist.playlistId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.get(widget.playlist.playlistId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      return true;
    }

    ///IF PLAYLIST IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.containsKey(widget.playlist.playlistId)) {
      return false;
    }

    ///IF PLAYLIST IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    return widget.playlist.isInCart;
  }
}