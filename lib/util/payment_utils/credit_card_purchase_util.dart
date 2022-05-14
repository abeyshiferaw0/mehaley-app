import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/credit_card/credit_card_generate_checkout_url_bloc/credit_card_generate_checkout_url_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/credit_card_check_out_api_result_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_credit_card_generate_checkout_url.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class CreditCardPurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongCreditCardPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.MINI_PLAYER_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongCreditCardPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources: AppPurchasedSources.SONG_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void songPreviewModeDialogBuyButtonOnClick(context, Song song) {
    ///STEP => SHOW BUYING DIALOGS
    startSongCreditCardPurchase(
      context: context,
      song: song,
      isFromItemSelfPage: false,
      appPurchasedSources:
          AppPurchasedSources.SONG_PREVIEW_MODE_DIALOG_BUY_BUTTON_ON_CLICK,
    );
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///STEP => SHOW BUYING DIALOGS
    startPlaylistCreditCardPurchase(
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
    startPlaylistCreditCardPurchase(
      context: context,
      playlist: playlist,
      isFromItemSelfPage: isFromPlaylistPage,
      appPurchasedSources:
          AppPurchasedSources.PLAYLIST_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///STEP => SHOW BUYING DIALOGS
    startAlbumCreditCardPurchase(
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
    startAlbumCreditCardPurchase(
      context: context,
      album: album,
      isFromItemSelfPage: isFromAlbumPage,
      appPurchasedSources: AppPurchasedSources.ALBUM_MENU_BUY_BUTTON_ON_CLICK,
    );
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////

  ///START SONG CREDIT CARD PURCHASE
  static void startSongCreditCardPurchase({
    required BuildContext context,
    required Song song,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE CREDIT CARD CHECKOUT URL DIALOG

        return BlocProvider(
          create: (context) => CreditCardGenerateCheckoutUrlBloc(
            creditCardPurchaseRepository:
                AppRepositories.creditCardPurchaseRepository,
          ),
          child: DialogCreditCardGenerateCheckoutUrl(
            itemId: song.songId,
            purchasedItemType: PurchasedItemType.SONG_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ///START PLAYLIST CREDIT CARD PURCHASE
  static void startPlaylistCreditCardPurchase({
    required BuildContext context,
    required Playlist playlist,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE CREDIT CARD CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => CreditCardGenerateCheckoutUrlBloc(
            creditCardPurchaseRepository:
                AppRepositories.creditCardPurchaseRepository,
          ),
          child: DialogCreditCardGenerateCheckoutUrl(
            itemId: playlist.playlistId,
            purchasedItemType: PurchasedItemType.PLAYLIST_PAYMENT,
            isFromSelfPage: isFromItemSelfPage,
            appPurchasedSources: appPurchasedSources,
          ),
        );
      },
    );
  }

  ///START ALBUM CREDIT CARD PURCHASE
  static void startAlbumCreditCardPurchase({
    required BuildContext context,
    required Album album,
    required bool isFromItemSelfPage,
    required AppPurchasedSources appPurchasedSources,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        ///SHOW GENERATE CREDIT CARD CHECKOUT URL DIALOG
        return BlocProvider(
          create: (context) => CreditCardGenerateCheckoutUrlBloc(
            creditCardPurchaseRepository:
                AppRepositories.creditCardPurchaseRepository,
          ),
          child: DialogCreditCardGenerateCheckoutUrl(
            itemId: album.albumId,
            purchasedItemType: PurchasedItemType.ALBUM_PAYMENT,
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

  static String getCyberSourceFormDataUrl(
      String checkOutUrl, CreditCardResult creditCardResult) {
    print(
        "CYYBERRR => ${AppApi.cyberSourceFormPaymentUrl}?access_key=${creditCardResult.accessKey}&profile_id=${creditCardResult.profileId}&transaction_uuid=${creditCardResult.transactionUuid}&signed_field_names=${creditCardResult.signedFieldNames}&unsigned_field_names=${creditCardResult.unsignedFieldNames}&signed_date_time=${creditCardResult.signedDateTime}&locale=${creditCardResult.locale}&transaction_type=${creditCardResult.transactionType}&reference_number=${creditCardResult.referenceNumber}&amount=${creditCardResult.amount}&currency=${creditCardResult.currency}&signature=${Uri.encodeComponent(creditCardResult.signature)}");
    return "${AppApi.cyberSourceFormPaymentUrl}?access_key=${creditCardResult.accessKey}&profile_id=${creditCardResult.profileId}&transaction_uuid=${creditCardResult.transactionUuid}&signed_field_names=${creditCardResult.signedFieldNames}&unsigned_field_names=${creditCardResult.unsignedFieldNames}&signed_date_time=${creditCardResult.signedDateTime}&locale=${creditCardResult.locale}&transaction_type=${creditCardResult.transactionType}&reference_number=${creditCardResult.referenceNumber}&amount=${creditCardResult.amount}&currency=${creditCardResult.currency}&signature=${Uri.encodeComponent(creditCardResult.signature)}";
  }
}
