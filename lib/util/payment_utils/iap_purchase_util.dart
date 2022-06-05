import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_consumable_purchase_bloc/iap_consumable_purchase_bloc.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/enums/iap_product_types.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class IapPurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongIapPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.MINI_PLAYER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongIapPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.SONG_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songPreviewModeDialogBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongIapPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources:
          AppPurchasedSources.SONG_PREVIEW_MODE_DIALOG_BUY_BUTTON_ON_CLICK,
    );
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistIapPurchase(
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
    startPlaylistIapPurchase(
      context: context,
      playlist: playlist,
      isFromItemSelfPage: isFromPlaylistPage,
      appPurchasedSources:
          AppPurchasedSources.PLAYLIST_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumIapPurchase(
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
    startAlbumIapPurchase(
      context: context,
      album: album,
      isFromItemSelfPage: isFromAlbumPage,
      appPurchasedSources: AppPurchasedSources.ALBUM_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////

  ///START SONG IAP PURCHASE
  static void startSongIapPurchase({
    required BuildContext context,
    required Song song,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    BlocProvider.of<IapConsumablePurchaseBloc>(context).add(
      StartConsumablePurchaseEvent(
        iapProduct: IapProduct(
          productId: song.priceDollar.productId,
          productPrice: song.priceDollar.productPrice,
          iapProductType: IapProductTypes.SONG,
        ),
        itemId: song.songId,
        purchasedItemType: PurchasedItemType.SONG_PAYMENT,
        isFromItemSelfPage: isFromItemSelfPage,
        appPurchasedSources: appPurchasedSources,
      ),
    );
  }

  ///START PLAYLIST IAP PURCHASE
  static void startPlaylistIapPurchase({
    required BuildContext context,
    required Playlist playlist,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    BlocProvider.of<IapConsumablePurchaseBloc>(context).add(
      StartConsumablePurchaseEvent(
        iapProduct: IapProduct(
          productId: playlist.priceDollar.productId,
          productPrice: playlist.priceDollar.productPrice,
          iapProductType: IapProductTypes.PLAYLIST,
        ),
        itemId: playlist.playlistId,
        purchasedItemType: PurchasedItemType.PLAYLIST_PAYMENT,
        isFromItemSelfPage: isFromItemSelfPage,
        appPurchasedSources: appPurchasedSources,
      ),
    );
  }

  ///START ALBUM IAP PURCHASE
  static void startAlbumIapPurchase({
    required BuildContext context,
    required Album album,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    BlocProvider.of<IapConsumablePurchaseBloc>(context).add(
      StartConsumablePurchaseEvent(
        iapProduct: IapProduct(
          productId: album.priceDollar.productId,
          productPrice: album.priceDollar.productPrice,
          iapProductType: IapProductTypes.ALBUM,
        ),
        itemId: album.albumId,
        purchasedItemType: PurchasedItemType.ALBUM_PAYMENT,
        isFromItemSelfPage: isFromItemSelfPage,
        appPurchasedSources: appPurchasedSources,
      ),
    );
  }
}
