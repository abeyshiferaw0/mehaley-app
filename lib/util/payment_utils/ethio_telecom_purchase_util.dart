import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/ethio_telecom/ethio_telecom_payment_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_ethio_telecom_payment.dart';
import 'package:mehaley/ui/common/dialog/payment/phone_verfication/dialog_phone_verfication_page_one.dart';
import 'package:mehaley/util/auth_util.dart';

class EthioTelecomPurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongEthioTelePurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.MINI_PLAYER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongEthioTelePurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.SONG_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songPreviewModeDialogBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongEthioTelePurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources:
          AppPurchasedSources.SONG_PREVIEW_MODE_DIALOG_BUY_BUTTON_ON_CLICK,
    );
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistEthioTelePurchase(
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
    startPlaylistEthioTelePurchase(
      context: context,
      playlist: playlist,
      isFromItemSelfPage: isFromPlaylistPage,
      appPurchasedSources:
          AppPurchasedSources.PLAYLIST_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumEthioTelePurchase(
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
    startAlbumEthioTelePurchase(
      context: context,
      album: album,
      isFromItemSelfPage: isFromAlbumPage,
      appPurchasedSources: AppPurchasedSources.ALBUM_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////

  ///START SONG ETHIO TELECOM PURCHASE
  static void startSongEthioTelePurchase({
    required BuildContext context,
    required Song song,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    ///CHECK IF PHONE AUTH IS REQUIRED
    if (isPhoneAuthRequiredForPurchase()) {
      ///FIRST AUTHENTICATE USER WITH PHONE NUMBER BEFORE PURCHASE
      showDialog(
        context: context,
        builder: (_) {
          return DialogPhoneVerificationPageOne(
            onAuthSuccess: () {
              ///AFTER AUTH IS COMPLETE PROCEED PAYMENT PROCESS BY
              ///SHOW ETHIO TELECOM SONG PURCHASING DIALOG
              showSongPurchaseDialog(
                context,
                song,
                isFromItemSelfPage,
                appPurchasedSources,
              );
            },
          );
        },
      );
    } else {
      ///SHOW ETHIO TELECOM SONG PURCHASING DIALOG
      showSongPurchaseDialog(
        context,
        song,
        isFromItemSelfPage,
        appPurchasedSources,
      );
    }
  }

  ///START PLAYLIST ETHIO TELECOM PURCHASE
  static void startPlaylistEthioTelePurchase({
    required BuildContext context,
    required Playlist playlist,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    if (isPhoneAuthRequiredForPurchase()) {
      ///FIRST AUTHENTICATE USER WITH PHONE NUMBER BEFORE PURCHASE
      showDialog(
        context: context,
        builder: (_) {
          ///SHOW GENERATE ETHIO TELECOM PURCHASING DIALOG
          return DialogPhoneVerificationPageOne(
            onAuthSuccess: () {
              showPlaylistPurchaseDialog(
                context,
                playlist,
                isFromItemSelfPage,
                appPurchasedSources,
              );
            },
          );
        },
      );
    } else {
      ///SHOW PLAYLIST PURCHASE DIALOG
      showPlaylistPurchaseDialog(
        context,
        playlist,
        isFromItemSelfPage,
        appPurchasedSources,
      );
    }
  }

  ///START ALBUM ETHIO TELECOM PURCHASE
  static void startAlbumEthioTelePurchase({
    required BuildContext context,
    required Album album,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    if (isPhoneAuthRequiredForPurchase()) {
      ///FIRST AUTHENTICATE USER WITH PHONE NUMBER BEFORE PURCHASE
      showDialog(
        context: context,
        builder: (_) {
          ///SHOW GENERATE ETHIO TELECOM PURCHASING DIALOG
          return DialogPhoneVerificationPageOne(
            onAuthSuccess: () {
              showAlbumPurchaseDialog(
                context,
                album,
                isFromItemSelfPage,
                appPurchasedSources,
              );
            },
          );
        },
      );
    } else {
      ///SHOW ALBUM PURCHASE DIALOG
      showAlbumPurchaseDialog(
        context,
        album,
        isFromItemSelfPage,
        appPurchasedSources,
      );
    }
  }

  ////////////////////////////////////
  /////////OTHER FUNCTIONS////////////
  ///////////////////////////////////

  static bool isPhoneAuthRequiredForPurchase() {
    ///FOR
    ///IF isUserPhoneAuthenticated IS NULL
    ///(MEANING NEW USERS SINCE THIS DB CHANGE)
    if (AuthUtil.isUserPhoneAuthenticated() == null) {
      if (AuthUtil.isAuthTypePhoneNumber() && AuthUtil.isUserPhoneEthiopian()) {
        return false;
      } else {
        return true;
      }
    } else {
      ///FOR
      ///IF isUserPhoneAuthenticated IS NOT NULL
      ///(MEANING NEW USERS SINCE THIS DB CHANGE WHOBLOGED IN AGAIN)
      ///OR NEW INSTALLED USERS
      if (AuthUtil.isUserPhoneAuthenticated()! &&
          AuthUtil.isUserPhoneEthiopian()) {
        return false;
      } else {
        return true;
      }
    }
  }

  static showSongPurchaseDialog(
      BuildContext context, song, isFromItemSelfPage, appPurchasedSources) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW ETHIO TELECOM PURCHASING DIALOG
        return BlocProvider(
          create: (context) => EthioTelecomPaymentBloc(
            ethioTelecomPurchaseRepository:
                AppRepositories.ethioTelecomPurchaseRepository,
          ),
          child: DialogEthioTelecomPayment(
            itemId: song.songId,
            purchasedItemType: PurchasedItemType.SONG_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  static showPlaylistPurchaseDialog(
      context, playlist, isFromItemSelfPage, appPurchasedSources) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE ETHIO TELECOM PURCHASING DIALOG
        return BlocProvider(
          create: (context) => EthioTelecomPaymentBloc(
            ethioTelecomPurchaseRepository:
                AppRepositories.ethioTelecomPurchaseRepository,
          ),
          child: DialogEthioTelecomPayment(
            itemId: playlist.playlistId,
            purchasedItemType: PurchasedItemType.PLAYLIST_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  static showAlbumPurchaseDialog(
      context, album, isFromItemSelfPage, appPurchasedSources) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE ETHIO TELECOM PURCHASING DIALOG
        return BlocProvider(
          create: (context) => EthioTelecomPaymentBloc(
            ethioTelecomPurchaseRepository:
                AppRepositories.ethioTelecomPurchaseRepository,
          ),
          child: DialogEthioTelecomPayment(
            itemId: album.albumId,
            purchasedItemType: PurchasedItemType.ALBUM_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }
}
