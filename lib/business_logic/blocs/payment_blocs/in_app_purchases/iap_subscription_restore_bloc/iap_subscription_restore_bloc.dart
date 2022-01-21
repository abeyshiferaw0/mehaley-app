import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/repositories/iap_subscription_repository.dart';
import 'package:purchases_flutter/models/entitlement_info_wrapper.dart';
import 'package:purchases_flutter/models/purchaser_info_wrapper.dart';

part 'iap_subscription_restore_event.dart';
part 'iap_subscription_restore_state.dart';

class IapSubscriptionRestoreBloc
    extends Bloc<IapSubscriptionRestoreEvent, IapSubscriptionRestoreState> {
  IapSubscriptionRestoreBloc({required this.iapSubscriptionRepository})
      : super(IapSubscriptionRestoreInitial());

  final IapSubscriptionRepository iapSubscriptionRepository;

  @override
  Stream<IapSubscriptionRestoreState> mapEventToState(
      IapSubscriptionRestoreEvent event) async* {
    if (event is RestoreIapSubscriptionEvent) {
      yield IapSubscriptionRestoringState();
      try {
        PurchaserInfo restoredInfo =
            await iapSubscriptionRepository.restorePurchase();
        EntitlementInfo entitlementInfo = restoredInfo
            .entitlements.all['mehaleye_subscriptions_all_access_entitlement']!;
        if (entitlementInfo.isActive) {
          await iapSubscriptionRepository.setUserIsSubscribes(true);

          ///UNLOCK FEATURED
          yield IapSubscriptionRestoredState(
            isSubscribed: true,
          );
        } else {
          await iapSubscriptionRepository.setUserIsSubscribes(false);
          yield IapSubscriptionRestoredState(
            isSubscribed: false,
          );
        }
      } catch (e) {
        yield IapSubscriptionRestoringErrorState(
          error: e.toString(),
        );
      }
    }
  }
}
