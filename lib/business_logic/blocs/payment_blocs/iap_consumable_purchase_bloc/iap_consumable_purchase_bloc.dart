import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/data/repositories/iap_purchase_repository.dart';

part 'iap_consumable_purchase_event.dart';
part 'iap_consumable_purchase_state.dart';

class IapConsumablePurchaseBloc
    extends Bloc<IapConsumablePurchaseEvent, IapConsumablePurchaseState> {
  IapConsumablePurchaseBloc({required this.iapPurchaseRepository})
      : super(IapConsumablePurchaseInitial()) {
    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(
      (productItem) {
        ///SKIP IF PRODUCT IS A SUBSCRIPTION AND LET REVENUE CAT HANDLE IT
        ///MAKE SURE THE WORD 'SUBSCRIPTION' IN ALL PRODUCT ID'S IN APPLE AND GOOGLE
        if (productIsNotASubscription(productItem)) {
          _handlePurchaseUpdated(productItem);
        }
      },
    );

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      if (purchaseError != null) {
        print("errorerror=> ${purchaseError}");
        if (purchaseError.code != 'E_USER_CANCELLED') {
          this.add(
            IapPurchaseShowErrorEvent(
              dateTime: DateTime.now(),
              error:
                  'purchase-error: CODE=> ${purchaseError.code}  ${purchaseError.message}',
            ),
          );
        }
      } else {
        this.add(
          IapPurchaseShowErrorEvent(
            dateTime: DateTime.now(),
            error: 'purchase-error: unk',
          ),
        );
      }

      ///TODO
      ///CHECK IF ERROR BECAUSE OF BILLING AVALVABLILTY AND
      /// ///IAP NOT AVAILABLE
      //yield IapNotAvailableState(dateTime: DateTime.now());
    });

    // ///LISTEN TO IAP PURCHASE STREAM
    // final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   ///HANDLE PURCHASE UPDATES
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {
    //   ///SHOW IAP ERROR
    //   this.add(
    //     IapPurchaseShowErrorEvent(
    //       dateTime: DateTime.now(),
    //       error: error.toString(),
    //     ),
    //   );
    // });
  }

  late StreamSubscription _purchaseErrorSubscription;
  late StreamSubscription _purchaseUpdatedSubscription;
  final IapPurchaseRepository iapPurchaseRepository;
  late StreamSubscription _subscription;

  @override
  Stream<IapConsumablePurchaseState> mapEventToState(
      IapConsumablePurchaseEvent event) async* {
    if (event is StartConsumablePurchaseEvent) {
      yield IapConsumablePurchaseStartedState();
      try {
        ///CHECK IF INTERNET CONNECT IS AVAILABLE
        bool isNetAvailable =
            await iapPurchaseRepository.checkInternetConnection();
        if (isNetAvailable) {
          ///SAVE LAST ITEM TO BE PURCHASED
          iapPurchaseRepository.saveLastItemToPurchase(
            event.appPurchasedItemType,
            event.itemId,
            event.isFromItemSelfPage,
            event.appPurchasedSources,
          );

          ///FETCH PRODUCT WITH ITEM PRODUCT STORE ID
          IAPItem iapItem = await iapPurchaseRepository.fetchProduct(
            event.iapProduct.productId,
          );

          ///PURCHASE PRODUCT
          iapPurchaseRepository.purchaseProduct(iapItem);
        } else {
          ///NO INTERNET
          yield IapConsumablePurchaseNoInternetState(dateTime: DateTime.now());
        }
      } catch (error) {
        yield IapConsumablePurchaseErrorState(
          error: error.toString(),
          dateTime: DateTime.now(),
        );
      }
    } else if (event is ShowIapPurchasePendingEvent) {
      yield ShowIapPurchasePendingState(dateTime: event.dateTime);
    } else if (event is IapPurchaseShowErrorEvent) {
      yield IapConsumablePurchaseErrorState(
        dateTime: event.dateTime,
        error: event.error,
      );
    } else if (event is IapPurchaseSuccessVerifyEvent) {
      yield IapPurchaseSuccessVerifyState(
        purchasedItem: event.purchasedItem,
        appPurchasedItemType: event.appPurchasedItemType,
        itemId: event.itemId,
        isFromSelfPage: event.isFromSelfPage,
        appPurchasedSources: event.appPurchasedSources,
        purchaseToken: event.purchaseToken,
      );
    }
  }

  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     print("_listenToPurchaseUpdated ${purchaseDetails.productID}");
  //
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       ///FIRE SHOW PENDING UI EVENT
  //       this.add(
  //         ShowIapPurchasePendingEvent(
  //           dateTime: DateTime.now(),
  //         ),
  //       );
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         ///SHOW PURCHASING ERROR
  //         this.add(
  //           IapPurchaseShowErrorEvent(
  //             dateTime: DateTime.now(),
  //             error: purchaseDetails.error != null
  //                 ? purchaseDetails.error!.message
  //                 : 'error inside purchasing update stream',
  //           ),
  //         );
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //           purchaseDetails.status == PurchaseStatus.restored) {
  //         ///GET LAST TO BE PURCHASED ITEM INFO
  //         Map<String, dynamic> info =
  //             iapPurchaseRepository.getLastItemToPurchase();
  //         //item type
  //         IapPurchasedItemType itemType = EnumToString.fromString(
  //           IapPurchasedItemType.values,
  //           info[AppValues.lastToBePurchasedItemTypeKey]!,
  //         )!;
  //         //purchase click source
  //         AppPurchasedSources appPurchasedSources = EnumToString.fromString(
  //           AppPurchasedSources.values,
  //           info[AppValues.lastToBePurchasedIapPurchasedSourcesKey]!,
  //         )!;
  //         //item id
  //         int itemId = info[AppValues.lastToBePurchasedItemIdKey]!;
  //         //is from self page
  //         bool isFromSelfPage =
  //             info[AppValues.lastToBePurchasedIsFromSelfPageKey]!;
  //
  //         ///YIELD SUCCESS AND VERIFY EVENT HERE
  //         this.add(
  //           IapPurchaseSuccessVerifyEvent(
  //             purchaseDetails: purchaseDetails,
  //             appPurchasedItemType: itemType,
  //             isFromSelfPage: isFromSelfPage,
  //             appPurchasedSources: appPurchasedSources,
  //             itemId: itemId,
  //           ),
  //         );
  //       }
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await InAppPurchase.instance.completePurchase(purchaseDetails);
  //       }
  //     }
  //   });
  // }

  void _handlePurchaseUpdated(PurchasedItem? purchasedItem) async {
    if (purchasedItem != null && purchasedItem.purchaseToken != null) {
      String? result = await FlutterInappPurchase.instance.finishTransaction(
        purchasedItem,
        isConsumable: true,
      );

      print("_handlePurchaseUpdated result ${purchasedItem.purchaseToken}");

      ///GET LAST TO BE PURCHASED ITEM INFO
      Map<String, dynamic> info = iapPurchaseRepository.getLastItemToPurchase();
      //item type
      AppPurchasedItemType itemType = EnumToString.fromString(
        AppPurchasedItemType.values,
        info[AppValues.lastToBePurchasedItemTypeKey]!,
      )!;
      //purchase click source
      AppPurchasedSources appPurchasedSources = EnumToString.fromString(
        AppPurchasedSources.values,
        info[AppValues.lastToBePurchasedIapPurchasedSourcesKey]!,
      )!;
      //item id
      int itemId = info[AppValues.lastToBePurchasedItemIdKey]!;
      //is from self page
      bool isFromSelfPage = info[AppValues.lastToBePurchasedIsFromSelfPageKey]!;

      print("INAPPPPP ID parame => ${purchasedItem.productId}");

      ///YIELD SUCCESS AND VERIFY EVENT HERE
      this.add(
        IapPurchaseSuccessVerifyEvent(
          purchasedItem: purchasedItem,
          appPurchasedItemType: itemType,
          purchaseToken: purchasedItem.purchaseToken!,
          isFromSelfPage: isFromSelfPage,
          appPurchasedSources: appPurchasedSources,
          itemId: itemId,
        ),
      );
    } else {
      this.add(
        IapPurchaseShowErrorEvent(
          dateTime: DateTime.now(),
          error: 'HANDLING_PURCHASE_PRODUCT_ITEM_IS_NULL',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _purchaseUpdatedSubscription.cancel();
    _purchaseErrorSubscription.cancel();
    _subscription.cancel();
    return super.close();
  }

  bool productIsNotASubscription(PurchasedItem? productItem) {
    bool isNotSub = true;
    if (productItem != null) {
      if (productItem.productId != null) {
        if (productItem.productId!.contains('subsciprion')) {
          isNotSub = false;
        }
      }
    }
    return isNotSub;
  }
}
