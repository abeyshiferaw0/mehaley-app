import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/payment_repository.dart';

part 'purchase_item_event.dart';
part 'purchase_item_state.dart';

class PurchaseItemBloc extends Bloc<PurchaseItemEvent, PurchaseItemState> {
  PurchaseItemBloc({required this.paymentRepository})
      : super(PurchaseItemInitial());

  final PaymentRepository paymentRepository;

  @override
  Future<void> close() {
    paymentRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<PurchaseItemState> mapEventToState(PurchaseItemEvent event) async* {
    if (event is PurchaseItem) {
      yield PurchaseItemLoadingState();

      try {
        final Response response = await paymentRepository.purchaseItem(
          event.itemId,
          event.purchasedItemType,
        );

        ///CLEAR ALL CACHE
        await paymentRepository.deleteAllCache();
        // ///CLEAR HOME PAGE CACHE ON PURCHASE SUCCESS
        // await paymentRepository.clearHomePageCache();
        //
        // ///CLEAR WALLET PAGE CACHE ON PURCHASE SUCCESS
        // await paymentRepository.clearWalletPageCache();
        //
        // ///CLEAR CART PAGE CACHE ON PURCHASE SUCCESS
        // await paymentRepository.clearCartPageCache();
        //
        // ///CLEAR LIBRARY PAGE CACHE BASED ON PURCHASED ITEM
        // ///CLEAR ALBUM OR PLAYLIST PAGE CACHE BASED ON PURCHASED ITEM
        // if (event.purchasedItemType == PurchasedItemType.SONG_PAYMENT) {
        //   await paymentRepository.clearLibraryPurchasedSongsCache();
        // }
        // if (event.purchasedItemType == PurchasedItemType.ALBUM_PAYMENT) {
        //   await paymentRepository.clearLibraryPurchasedAlbumsCache();
        //   await paymentRepository.clearAlbumPageCache(event.itemId);
        // }
        // if (event.purchasedItemType == PurchasedItemType.PLAYLIST_PAYMENT) {
        //   await paymentRepository.clearLibraryPurchasedPlaylistsCache();
        //   await paymentRepository.clearPlaylistsPageCache(event.itemId);
        // }

        yield PurchaseItemLoadedState(
          itemId: event.itemId,
          purchasedItemType: event.purchasedItemType,
        );
      } catch (error) {
        yield PurchaseItemLoadingErrorState(error: error.toString());
      }
    }
  }
}
