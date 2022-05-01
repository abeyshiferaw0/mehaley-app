import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/complete_purchase_dialog_bloc/complete_purchase_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_complete_purchase.dart';
import 'package:mehaley/util/payment_utils/ethio_telecom_purchase_util.dart';
import 'package:mehaley/util/payment_utils/iap_purchase_util.dart';
import 'package:mehaley/util/payment_utils/telebirr_purchase_util.dart';
import 'package:mehaley/util/payment_utils/yenepay_purchase_util.dart';

class PurchaseUtil {
  ////////////////////////////////////
  /////////MAIN FUNCTIONS////////////
  ///////////////////////////////////
  static void miniPlayerBuyButtonOnClick(context, Song song) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.miniPlayerBuyButtonOnClick(
        context,
        song,
      );
    } else {
      ///FOR ANDROID
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: song.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.miniPlayerBuyButtonOnClick(
            context,
            song,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.miniPlayerBuyButtonOnClick(
            context,
            song,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.miniPlayerBuyButtonOnClick(
            context,
            song,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.miniPlayerBuyButtonOnClick(
            context,
            song,
          );
        },
      );
    }
  }

  static void songMenuBuyButtonOnClick(context, Song song) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.songMenuBuyButtonOnClick(
        context,
        song,
      );
    } else {
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: song.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.songMenuBuyButtonOnClick(
            context,
            song,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.songMenuBuyButtonOnClick(
            context,
            song,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.songMenuBuyButtonOnClick(
            context,
            song,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.songMenuBuyButtonOnClick(
            context,
            song,
          );
        },
      );
    }
  }

  static void songPreviewModeDialogBuyButtonOnClick(context, Song song) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.songPreviewModeDialogBuyButtonOnClick(
        context,
        song,
      );
    } else {
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: song.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.songPreviewModeDialogBuyButtonOnClick(
            context,
            song,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.songPreviewModeDialogBuyButtonOnClick(
            context,
            song,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.songPreviewModeDialogBuyButtonOnClick(
            context,
            song,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.songPreviewModeDialogBuyButtonOnClick(
            context,
            song,
          );
        },
      );
    }
  }

  static void playlistPageHeaderBuyButtonOnClick(context, Playlist playlist) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.playlistPageHeaderBuyButtonOnClick(
        context,
        playlist,
      );
    } else {
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: playlist.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.playlistPageHeaderBuyButtonOnClick(
            context,
            playlist,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.playlistPageHeaderBuyButtonOnClick(
            context,
            playlist,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.playlistPageHeaderBuyButtonOnClick(
            context,
            playlist,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.playlistPageHeaderBuyButtonOnClick(
            context,
            playlist,
          );
        },
      );
    }
  }

  static void playlistMenuBuyButtonOnClick(
      context, Playlist playlist, bool isFromPlaylistPage) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.playlistMenuBuyButtonOnClick(
        context,
        playlist,
        isFromPlaylistPage,
      );
    } else {
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: playlist.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.playlistMenuBuyButtonOnClick(
            context,
            playlist,
            isFromPlaylistPage,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.playlistMenuBuyButtonOnClick(
            context,
            playlist,
            isFromPlaylistPage,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.playlistMenuBuyButtonOnClick(
            context,
            playlist,
            isFromPlaylistPage,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.playlistMenuBuyButtonOnClick(
            context,
            playlist,
            isFromPlaylistPage,
          );
        },
      );
    }
  }

  static void albumPageHeaderBuyButtonOnClick(context, Album album) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.albumPageHeaderBuyButtonOnClick(
        context,
        album,
      );
    } else {
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: album.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.albumPageHeaderBuyButtonOnClick(
            context,
            album,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.albumPageHeaderBuyButtonOnClick(
            context,
            album,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.albumPageHeaderBuyButtonOnClick(
            context,
            album,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.albumPageHeaderBuyButtonOnClick(
            context,
            album,
          );
        },
      );
    }
  }

  static void albumMenuBuyButtonOnClick(
      context, Album album, bool isFromAlbumPage) {
    ///PROCEED WITH ONLY IAP FOR IOS DEVICES
    if (Platform.isIOS) {
      ///
      IapPurchaseUtil.albumMenuBuyButtonOnClick(
        context,
        album,
        isFromAlbumPage,
      );
    } else {
      ///STEP => SHOW BUYING DIALOGS
      startPurchaseProcess(
        context: context,
        priceEtb: album.priceEtb,
        onTelebirrSelected: () {
          TelebirrPurchaseUtil.albumMenuBuyButtonOnClick(
            context,
            album,
            isFromAlbumPage,
          );
        },
        onEthioTelecomSelected: () {
          EthioTelecomPurchaseUtil.albumMenuBuyButtonOnClick(
            context,
            album,
            isFromAlbumPage,
          );
        },
        onYenepaySelected: () {
          YenepayPurchaseUtil.albumMenuBuyButtonOnClick(
            context,
            album,
            isFromAlbumPage,
          );
        },
        onInAppSelected: () {
          IapPurchaseUtil.albumMenuBuyButtonOnClick(
            context,
            album,
            isFromAlbumPage,
          );
        },
      );
    }
  }

  ////////////////////////////////////
  /////////UTIL FUNCTIONS////////////
  ///////////////////////////////////
  ///SHOW PURCHASE DIALOG
  static void startPurchaseProcess({
    required BuildContext context,
    required double priceEtb,
    required VoidCallback onEthioTelecomSelected,
    required VoidCallback onYenepaySelected,
    required VoidCallback onTelebirrSelected,
    required VoidCallback onInAppSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CompletePurchaseBloc>(
              create: (context) => CompletePurchaseBloc(
                paymentRepository: AppRepositories.paymentRepository,
              ),
            ),
            BlocProvider<PreferredPaymentMethodBloc>(
              create: (context) => PreferredPaymentMethodBloc(
                paymentRepository: AppRepositories.paymentRepository,
              ),
            ),
          ],
          child: DialogCompletePurchase(
            priceEtb: priceEtb,
            onEthioTelecomSelected: onEthioTelecomSelected,
            onYenepaySelected: onYenepaySelected,
            onTelebirrSelected: onTelebirrSelected,
            onInAppSelected: onInAppSelected,
          ),
        );
      },
    );
  }
}
