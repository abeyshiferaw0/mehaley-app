import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/yenepay/yenepay_generate_checkout_url_bloc/yenepay_generate_checkout_url_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_yenepay_generate_checkout_url.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class YenepayPurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongYenepayPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.MINI_PLAYER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongYenepayPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.SONG_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songPreviewModeDialogBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongYenepayPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources:
          AppPurchasedSources.SONG_PREVIEW_MODE_DIALOG_BUY_BUTTON_ON_CLICK,
    );
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistYenepayPurchase(
      context: context,
      playlist: playlist,
      isFromItemSelfPage: true,
      appPurchasedSources:
          AppPurchasedSources.PLAYLIST_PAGE_HEADER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void playlistMenuBuyButtonOnClick(
      context, Playlist playlist, bool isFromPlaylistPage) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistYenepayPurchase(
      context: context,
      playlist: playlist,
      isFromItemSelfPage: isFromPlaylistPage,
      appPurchasedSources:
          AppPurchasedSources.PLAYLIST_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumYenepayPurchase(
      context: context,
      album: album,
      isFromItemSelfPage: true,
      appPurchasedSources:
          AppPurchasedSources.ALBUM_PAGE_HEADER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void albumMenuBuyButtonOnClick(
      context, Album album, bool isFromAlbumPage) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumYenepayPurchase(
      context: context,
      album: album,
      isFromItemSelfPage: isFromAlbumPage,
      appPurchasedSources: AppPurchasedSources.ALBUM_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////

  ///START SONG YENEPAY PURCHASE
  static void startSongYenepayPurchase({
    required BuildContext context,
    required Song song,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE YENEPAY CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => YenepayGenerateCheckoutUrlBloc(
            yenepayPurchaseRepository:
                AppRepositories.yenepayPurchaseRepository,
          ),
          child: DialogYenepayGenerateCheckoutUrl(
            itemId: song.songId,
            item: song,
            itemNameEn:
                '${song.songName.textEn} by ${PagesUtilFunctions.getArtistsNames(song.artistsName, context)}',
            price: song.priceEtb,
            appPurchasedItemType: AppPurchasedItemType.SONG_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ///START PLAYLIST YENEPAY PURCHASE
  static void startPlaylistYenepayPurchase({
    required BuildContext context,
    required Playlist playlist,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE YENEPAY CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => YenepayGenerateCheckoutUrlBloc(
            yenepayPurchaseRepository:
                AppRepositories.yenepayPurchaseRepository,
          ),
          child: DialogYenepayGenerateCheckoutUrl(
            itemId: playlist.playlistId,
            item: playlist,
            itemNameEn: '${playlist.playlistNameText.textEn}',
            price: playlist.priceEtb,
            appPurchasedItemType: AppPurchasedItemType.PLAYLIST_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ///START ALBUM YENEPAY PURCHASE
  static void startAlbumYenepayPurchase({
    required BuildContext context,
    required Album album,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE YENEPAY CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => YenepayGenerateCheckoutUrlBloc(
            yenepayPurchaseRepository:
                AppRepositories.yenepayPurchaseRepository,
          ),
          child: DialogYenepayGenerateCheckoutUrl(
            itemId: album.albumId,
            item: album,
            itemNameEn: '${album.albumTitle.textEn}',
            price: album.priceEtb,
            appPurchasedItemType: AppPurchasedItemType.ALBUM_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ////////////////////////////////////
  /////////OTHER FUNCTIONS////////////
  ///////////////////////////////////
  static bool isSuccessReturnUrl(String s) {
    Uri returnUrl = Uri.parse(s);
    Uri successReturnUrl = Uri.parse(YenepayValues.successUrl);
    if (returnUrl.scheme == successReturnUrl.scheme &&
        returnUrl.host == successReturnUrl.host) {
      return true;
    }
    return false;
  }

  static bool isCancelReturnUrl(String s) {
    Uri returnUrl = Uri.parse(s);
    Uri cancelReturnUrl = Uri.parse(YenepayValues.cancelUrl);
    if (returnUrl.scheme == cancelReturnUrl.scheme &&
        returnUrl.host == cancelReturnUrl.host) {
      return true;
    }
    return false;
  }

  static bool isFailureReturnUrl(String s) {
    Uri returnUrl = Uri.parse(s);
    Uri failureReturnUrl = Uri.parse(YenepayValues.failureUrl);
    if (returnUrl.scheme == failureReturnUrl.scheme &&
        returnUrl.host == failureReturnUrl.host) {
      return true;
    }
    return false;
  }
}
