import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/telebirr/telebirr_generate_checkout_url_bloc/telebirr_generate_checkout_url_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_telebirr_generate_checkout_url.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class TelebirrPurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongTelebirrPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.MINI_PLAYER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongTelebirrPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.SONG_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songPreviewModeDialogBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongTelebirrPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources:
          AppPurchasedSources.SONG_PREVIEW_MODE_DIALOG_BUY_BUTTON_ON_CLICK,
    );
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistTelebirrPurchase(
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
    startPlaylistTelebirrPurchase(
      context: context,
      playlist: playlist,
      isFromItemSelfPage: isFromPlaylistPage,
      appPurchasedSources:
          AppPurchasedSources.PLAYLIST_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumTelebirrPurchase(
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
    startAlbumTelebirrPurchase(
      context: context,
      album: album,
      isFromItemSelfPage: isFromAlbumPage,
      appPurchasedSources: AppPurchasedSources.ALBUM_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////

  ///START SONG TELEBIRR PURCHASE
  static void startSongTelebirrPurchase({
    required BuildContext context,
    required Song song,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE TELEBIRR CHECKOUT URL DIALOG

        return BlocProvider(
          create: (context) => TelebirrGenerateCheckoutUrlBloc(
            telebirrPurchaseRepository:
                AppRepositories.telebirrPurchaseRepository,
          ),
          child: DialogTelebirrGenerateCheckoutUrl(
            itemId: song.songId,
            appPurchasedItemType: AppPurchasedItemType.SONG_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ///START PLAYLIST TELEBIRR PURCHASE
  static void startPlaylistTelebirrPurchase({
    required BuildContext context,
    required Playlist playlist,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE TELEBIRR CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => TelebirrGenerateCheckoutUrlBloc(
            telebirrPurchaseRepository:
                AppRepositories.telebirrPurchaseRepository,
          ),
          child: DialogTelebirrGenerateCheckoutUrl(
            itemId: playlist.playlistId,
            appPurchasedItemType: AppPurchasedItemType.PLAYLIST_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ///START ALBUM TELEBIRR PURCHASE
  static void startAlbumTelebirrPurchase({
    required BuildContext context,
    required Album album,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE TELEBIRR CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => TelebirrGenerateCheckoutUrlBloc(
            telebirrPurchaseRepository:
                AppRepositories.telebirrPurchaseRepository,
          ),
          child: DialogTelebirrGenerateCheckoutUrl(
            itemId: album.albumId,
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
  static bool isCompletedReturnUrl(String s) {
    Uri curUrl = Uri.parse(s);
    Uri completedUrl = Uri.parse(WebPaymentValues.completedUrl);
    if (PagesUtilFunctions.isUrlsEqual(curUrl, completedUrl)) {
      return true;
    }
    return false;
  }

  static bool isFreeReturnUrl(String s) {
    Uri curUrl = Uri.parse(s);
    Uri isFreeUrl = Uri.parse(WebPaymentValues.isFreeUrl);
    if (PagesUtilFunctions.isUrlsEqual(curUrl, isFreeUrl)) {
      return true;
    }
    return false;
  }

  static bool isAlreadyPaidReturnUrl(String s) {
    Uri curUrl = Uri.parse(s);
    Uri alreadyPurchasedUrl = Uri.parse(WebPaymentValues.alreadyPurchasedUrl);
    if (PagesUtilFunctions.isUrlsEqual(curUrl, alreadyPurchasedUrl)) {
      return true;
    }
    return false;
  }

  static bool isFailureReturnUrl(String s) {
    Uri curUrl = Uri.parse(s);
    Uri failureUrl = Uri.parse(WebPaymentValues.failureUrl);
    if (PagesUtilFunctions.isUrlsEqual(curUrl, failureUrl)) {
      return true;
    }
    return false;
  }

  static bool isReturnUrl(String? returnUrl) {
    if (returnUrl == null) return false;
    Uri url = Uri.parse(returnUrl);

    if (url.host == Uri.parse(AppApi.baseUrl).host) {
      return true;
    }

    return false;
  }

  static bool isResultSuccessUrl(String rUrl) {
    String? returnUrl = removeUrlHash(rUrl);
    if (returnUrl == null) return false;
    Uri url = Uri.parse(returnUrl);

    if (url.path.contains('ammsdkpay') && url.path.contains('result')) {
      if (url.queryParameters['status'] != null) {
        if (url.queryParameters['status'] == '200') {
          return true;
        }
      }
    }
    return false;
  }

  static String getResultSuccessUrlStatus(String rUrl) {
    String returnUrl = removeUrlHash(rUrl)!;

    Uri url = Uri.parse(returnUrl);

    if (url.path.contains('ammsdkpay') && url.path.contains('result')) {
      if (url.queryParameters['status'] != null) {
        return url.queryParameters['status']!;
      }
    }
    throw 'STATUS MISSING FROM getResultSuccessUrlStatus // ${returnUrl}';
  }

  static bool isResultFailureUrl(String rUrl) {
    String? returnUrl = removeUrlHash(rUrl);
    if (returnUrl == null) return false;
    Uri url = Uri.parse(returnUrl);

    if (url.path.contains('ammsdkpay') && url.path.contains('result')) {
      if (url.queryParameters['status'] != null) {
        if (url.queryParameters['status'] != '200') {
          return true;
        }
      }
    }
    return false;
  }

  static String? removeUrlHash(String? url) {
    if (url != null) {
      if (url.contains('/#/')) {
        return url.replaceAll('/#/', '/');
      }
    }

    return url;
  }
}
