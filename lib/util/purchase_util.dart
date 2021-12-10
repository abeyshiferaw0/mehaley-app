import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_purchase_success_transparent.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class PurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(
      context, GlobalKey<NavigatorState> navigatorKey, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongBuyingProcess(
      context: context,
      song: song,
      onPurchasesSuccess: () {
        ///STEP => STOP PLAYER
        BlocProvider.of<AudioPlayerBloc>(context).add(StopPlayerEvent());

        ///STEP => GO TO PURCHASED SONGS
        goToLibraryPageWithNavigatorKey(
          navigatorKey,
          LibraryFromOtherPageTypes.PURCHASED_SONGS,
        );
      },
    );
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongBuyingProcess(
      context: context,
      song: song,
      onPurchasesSuccess: () {
        ///STEP => GO TO PURCHASED SONGS
        goToLibraryPage(
          context,
          LibraryFromOtherPageTypes.PURCHASED_SONGS,
        );
      },
    );
  }

  static void songPreviewModeDialogBuyButtonOnClick(
      context, GlobalKey<NavigatorState> navigatorKey, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongBuyingProcess(
      context: context,
      song: song,
      onPurchasesSuccess: () {
        ///STEP => GO TO PURCHASED SONGS
        goToLibraryPageWithNavigatorKey(
          navigatorKey,
          LibraryFromOtherPageTypes.PURCHASED_SONGS,
        );
      },
    );
  }

  static void playlistHomePageBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistBuyingProcess(
      context: context,
      playlist: playlist,
      onPurchasesSuccess: () {
        ///STEP => GO TO PURCHASED ALBUM PAGE
        goToPlaylistPage(
          context,
          playlist,
        );

        ///STEP => SHOW TRANSPARENT SUCCESS ANIMATION
        showPlaylistSuccessTransparentDialog(
          context,
          playlist,
        );
      },
    );
  }

  static void albumHomePageBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumBuyingProcess(
      context: context,
      album: album,
      onPurchasesSuccess: () {
        ///STEP => GO TO PURCHASED ALBUM PAGE
        goToAlbumPage(
          context,
          album,
        );

        ///STEP => SHOW TRANSPARENT SUCCESS ANIMATION
        showAlbumSuccessTransparentDialog(
          context,
          album,
        );
      },
    );
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistBuyingProcess(
      context: context,
      playlist: playlist,
      onPurchasesSuccess: () {
        ///STEP => GO TO PURCHASED PLAYLIST PAGE
        goToPlaylistPage(
          context,
          playlist,
        );

        ///STEP => SHOW TRANSPARENT SUCCESS ANIMATION
        showPlaylistSuccessTransparentDialog(
          context,
          playlist,
        );
      },
    );
  }

  static void playlistMenuBuyButtonOnClick(
      context, Playlist playlist, bool isFromPlaylistPage) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistBuyingProcess(
      context: context,
      playlist: playlist,
      onPurchasesSuccess: () {
        if (isFromPlaylistPage) {
          ///IF FROM PLAYLIST PAGE
          ///STEP => GO TO PURCHASED PLAYLIST PAGE
          goToPlaylistPage(
            context,
            playlist,
          );

          ///STEP => SHOW TRANSPARENT SUCCESS ANIMATION
          showPlaylistSuccessTransparentDialog(
            context,
            playlist,
          );
        } else {
          ///IF NOT FROM PLAYLIST PAGE
          ///STEP => GO TO PURCHASED PLAYLIST
          goToLibraryPage(
            context,
            LibraryFromOtherPageTypes.PURCHASED_PLAYLISTS,
          );
        }
      },
    );
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumBuyingProcess(
      context: context,
      album: album,
      onPurchasesSuccess: () {
        ///STEP => GO TO PURCHASED ALBUM PAGE
        goToAlbumPage(
          context,
          album,
        );

        ///STEP => SHOW TRANSPARENT SUCCESS ANIMATION
        showAlbumSuccessTransparentDialog(
          context,
          album,
        );
      },
    );
  }

  static void albumMenuBuyButtonOnClick(
      context, Album album, bool isFromAlbumPage) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumBuyingProcess(
      context: context,
      album: album,
      onPurchasesSuccess: () {
        if (isFromAlbumPage) {
          ///IF FROM ALBUM PAGE
          ///STEP => GO TO PURCHASED ALBUM PAGE
          goToAlbumPage(
            context,
            album,
          );

          ///STEP => SHOW TRANSPARENT SUCCESS ANIMATION
          showAlbumSuccessTransparentDialog(
            context,
            album,
          );
        } else {
          ///IF NOT FROM ALBUM PAGE
          ///STEP => GO TO PURCHASED ALBUM
          goToLibraryPage(
            context,
            LibraryFromOtherPageTypes.PURCHASED_ALBUMS,
          );
        }
      },
    );
  }

  static void cartCheckoutButtonOnClick(context) {
    ///STEP => SHOW CART CHECK OUT DIALOGS
    startCartCheckOutProcess(
      context: context,
      onPurchasesSuccess: () {
        ///STEP => STOP PLAYER
        BlocProvider.of<AudioPlayerBloc>(context).add(StopPlayerEvent());

        ///STEP => GO TO ALL PURCHASED SONGS TAB
        goToLibraryPage(
          context,
          LibraryFromOtherPageTypes.PURCHASED_ALL_SONGS,
        );
      },
    );
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////
  ///SHOW BUYING DIALOGS
  static void startSongBuyingProcess({
    required context,
    required Song song,
    required VoidCallback onPurchasesSuccess,
  }) {
    PagesUtilFunctions.openPurchaseStatusDialog(
      context: context,
      purchasedItemType: PurchasedItemType.SONG_PAYMENT,
      itemId: song.songId,
      itemTitle: L10nUtil.translateLocale(song.songName, context),
      itemImageUrl: AppApi.baseUrl + song.albumArt.imageSmallPath,
      itemSubTitle: PagesUtilFunctions.getArtistsNames(
        song.artistsName,
        context,
      ),
      onPurchasesSuccess: onPurchasesSuccess,
    );
  }

  static void startAlbumBuyingProcess({
    required context,
    required Album album,
    required VoidCallback onPurchasesSuccess,
  }) {
    PagesUtilFunctions.openPurchaseStatusDialog(
      context: context,
      purchasedItemType: PurchasedItemType.ALBUM_PAYMENT,
      itemId: album.albumId,
      itemTitle: L10nUtil.translateLocale(album.albumTitle, context),
      itemImageUrl: AppApi.baseUrl + album.albumImages[0].imageSmallPath,
      itemSubTitle: L10nUtil.translateLocale(album.artist.artistName, context),
      onPurchasesSuccess: onPurchasesSuccess,
    );
  }

  static void startPlaylistBuyingProcess({
    required context,
    required Playlist playlist,
    required VoidCallback onPurchasesSuccess,
  }) {
    PagesUtilFunctions.openPurchaseStatusDialog(
      context: context,
      purchasedItemType: PurchasedItemType.PLAYLIST_PAYMENT,
      itemId: playlist.playlistId,
      itemTitle: L10nUtil.translateLocale(playlist.playlistNameText, context),
      itemImageUrl: AppApi.baseUrl + playlist.playlistImage.imageSmallPath,
      itemSubTitle:
          L10nUtil.translateLocale(playlist.playlistDescriptionText, context),
      onPurchasesSuccess: onPurchasesSuccess,
    );
  }

  static void startCartCheckOutProcess({
    required context,
    required VoidCallback onPurchasesSuccess,
  }) {
    PagesUtilFunctions.openCartCheckOutStatusDialog(
      context: context,
      onPurchasesSuccess: onPurchasesSuccess,
    );
  }

  ///GO TO LIB PAGE NORMAL WAY
  static void goToLibraryPage(
      context, LibraryFromOtherPageTypes libraryFromOtherPageTypes) {
    ///GO TO LIBRARY PAGE BASED ON => libraryFromOtherPageTypes
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouterPaths.libraryRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {
          AppValues.isLibraryForOffline: false,
          AppValues.isLibraryForOtherPage: true,
          AppValues.libraryFromOtherPageTypes: libraryFromOtherPageTypes,
        },
      ),
    );
  }

  ///GO TO PURCHASED ALBUM PAGE
  static void goToAlbumPage(context, album) {
    ///GO TO PURCHASED ALBUM PAGE
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouterPaths.albumRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {'albumId': album.albumId},
      ),
    );
  }

  ///GO TO PURCHASED PLAYLIST PAGE
  static void goToPlaylistPage(context, playlist) {
    ///GO TO PURCHASED PLAYLIST PAGE
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouterPaths.playlistRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {'playlistId': playlist.playlistId},
      ),
    );
  }

  ///GO TO LIB PAGE BY NAVIGATOR KEY
  static void goToLibraryPageWithNavigatorKey(
      GlobalKey<NavigatorState> navigatorKey,
      LibraryFromOtherPageTypes libraryFromOtherPageTypes) {
    ///GO TO LIBRARY PAGE BASED ON => libraryFromOtherPageTypes
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRouterPaths.libraryRoute,
      ModalRoute.withName(
        AppRouterPaths.homeRoute,
      ),
      arguments: ScreenArguments(
        args: {
          AppValues.isLibraryForOffline: false,
          AppValues.isLibraryForOtherPage: true,
          AppValues.libraryFromOtherPageTypes: libraryFromOtherPageTypes,
        },
      ),
    );
  }

  ///SHOW ALBUM PURCHASED SUCCESS TRANSPARENT DIALOG
  static void showAlbumSuccessTransparentDialog(context, Album album) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogPurchaseSuccess(
          title: AppLocale.of().albumPurchased,
          subTitle: L10nUtil.translateLocale(
            album.albumTitle,
            context,
          ),
        );
      },
    );
  }

  ///SHOW PLAYLIST PURCHASED SUCCESS TRANSPARENT DIALOG
  static void showPlaylistSuccessTransparentDialog(context, Playlist playlist) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogPurchaseSuccess(
          title: AppLocale.of().playlistPurchased,
          subTitle: L10nUtil.translateLocale(
            playlist.playlistNameText,
            context,
          ),
        );
      },
    );
  }
}
