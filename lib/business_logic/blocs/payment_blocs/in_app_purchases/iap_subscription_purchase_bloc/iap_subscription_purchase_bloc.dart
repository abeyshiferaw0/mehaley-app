import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mehaley/data/repositories/iap_subscription_repository.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'iap_subscription_purchase_event.dart';
part 'iap_subscription_purchase_state.dart';

class IapSubscriptionPurchaseBloc
    extends Bloc<IapSubscriptionPurchaseEvent, IapSubscriptionPurchaseState> {
  IapSubscriptionPurchaseBloc({required this.iapSubscriptionRepository})
      : super(IapSubscriptionPurchaseInitial());

  final IapSubscriptionRepository iapSubscriptionRepository;

  @override
  Stream<IapSubscriptionPurchaseState> mapEventToState(
      IapSubscriptionPurchaseEvent event) async* {
    if (event is PurchaseIapSubscriptionOfferingEvent) {
      yield IapSubscriptionPurchasingState();
      try {
        PurchaserInfo purchaserInfo = await iapSubscriptionRepository
            .purchaseSubscription(event.offering);
        EntitlementInfo entitlementInfo = purchaserInfo
            .entitlements.all['mehaleye_subscriptions_all_access_entitlement']!;
        if (entitlementInfo.isActive) {
          ///SET APP SUBSCRIBED TO TRUE
          await iapSubscriptionRepository.setUserIsSubscribes(true);

          ///UNLOCK FEATURED
          yield IapSubscriptionPurchasedState(
            isSubscribed: true,
          );
        } else {
          await iapSubscriptionRepository.setUserIsSubscribes(false);
          yield IapSubscriptionPurchasingErrorState(
            error: 'ENTITLEMENT IS NOT ACTIVE',
          );
        }
      } on PlatformException catch (e) {
        PurchasesErrorCode errorCode = PurchasesErrorHelper.getErrorCode(e);

        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          yield IapSubscriptionPurchasingErrorState(
            error: e.toString(),
          );
        }
      } catch (e) {
        yield IapSubscriptionPurchasingErrorState(
          error: e.toString(),
        );
      }
    }
  }
}
