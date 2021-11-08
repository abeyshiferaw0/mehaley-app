import 'package:easy_debounce/easy_debounce.dart';
import 'package:elf_play/business_logic/blocs/cart_page_bloc/cart_util_bloc/cart_util_bloc.dart';
import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import 'menu_item.dart';

class SongCartMenuItem extends StatefulWidget {
  const SongCartMenuItem({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  _SongCartMenuItemState createState() => _SongCartMenuItemState();
}

class _SongCartMenuItemState extends State<SongCartMenuItem> {
  @override
  @override
  Widget build(BuildContext context) {
    if (widget.song.isBought || widget.song.isFree) {
      return SizedBox();
    } else {
      return BlocBuilder<CartUtilBloc, CartUtilState>(
        buildWhen: (previousState, currentState) {
          if (currentState is CartUtilSongAddingState ||
              currentState is CartUtilSongAddedSuccessState ||
              currentState is CartUtilSongAddingErrorState) {
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
    ///ADD REMOVE SONG
    EasyDebounce.debounce(
      'SONG_CART_ADD_REMOVE',
      Duration(milliseconds: 800),
      () {
        BlocProvider.of<CartUtilBloc>(context).add(
          AddRemovedSongCartEvent(
            song: widget.song,
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
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return PhosphorIcons.shopping_cart_simple_fill;
      } else {
        return PhosphorIcons.shopping_cart_simple_light;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return PhosphorIcons.shopping_cart_simple_fill;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return PhosphorIcons.shopping_cart_simple_light;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return PhosphorIcons.shopping_cart_simple_fill;
    } else {
      return PhosphorIcons.shopping_cart_simple_light;
    }
  }

  Color preCartIconColor() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return AppColors.darkGreen;
      } else {
        return AppColors.grey.withOpacity(0.6);
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return AppColors.darkGreen;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return AppColors.grey.withOpacity(0.6);
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return AppColors.darkGreen;
    } else {
      return AppColors.grey.withOpacity(0.6);
    }
  }

  String preCartText() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return AppLocalizations.of(context)!.removeFromCart;
      } else {
        return AppLocalizations.of(context)!.addToCart;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return AppLocalizations.of(context)!.removeFromCart;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return AppLocalizations.of(context)!.addToCart;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    if (widget.song.isInCart) {
      return AppLocalizations.of(context)!.removeFromCart;
    } else {
      return AppLocalizations.of(context)!.addToCart;
    }
  }

  bool preButtonOnTap() {
    ///IF FOUND IN BOTH RECENTLY CART ADDED AND CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
            .containsKey(widget.song.songId) &&
        AppHiveBoxes.instance.recentlyCartRemovedSongBox
            .containsKey(widget.song.songId)) {
      int a = AppHiveBoxes.instance.recentlyCartAddedSongBox
          .get(widget.song.songId);
      int b = AppHiveBoxes.instance.recentlyCartRemovedSongBox
          .get(widget.song.songId);
      if (a > b) {
        return true;
      } else {
        return false;
      }
    }

    ///IF SONG IS FOUND IN RECENTLY CART ADDED
    if (AppHiveBoxes.instance.recentlyCartAddedSongBox
        .containsKey(widget.song.songId)) {
      return true;
    }

    ///IF SONG IS FOUND IN RECENTLY CART REMOVED
    if (AppHiveBoxes.instance.recentlyCartRemovedSongBox
        .containsKey(widget.song.songId)) {
      return false;
    }

    ///IF SONG IS NOT FOUND IN RECENTLY CART REMOVED USE ORIGINAL STATE
    return widget.song.isInCart;
  }
}
