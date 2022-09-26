import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/repositories/iap_subscription_repository.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

part 'iap_subscription_status_event.dart';
part 'iap_subscription_status_state.dart';

class IapSubscriptionStatusBloc
    extends Bloc<IapSubscriptionStatusEvent, IapSubscriptionStatusState> {
  IapSubscriptionStatusBloc({required this.iapSubscriptionRepository})
      : super(IapSubscriptionStatusInitial());

  final IapSubscriptionRepository iapSubscriptionRepository;

  @override
  Stream<IapSubscriptionStatusState> mapEventToState(
      IapSubscriptionStatusEvent event) async* {
    if (event is CheckIapSubscriptionEvent) {
      yield IapSubscriptionStatusCheckingState();
      try {
        PurchaserInfo purchaserInfo =
            await iapSubscriptionRepository.checkIapSubscription();
        EntitlementInfo entitlementInfo = purchaserInfo
            .entitlements.all['mehaleye_subscriptions_all_access_entitlement']!;

        if (entitlementInfo.isActive) {
          await iapSubscriptionRepository.setUserIsSubscribes(true);
        } else {
          bool isPreSub = iapSubscriptionRepository.getUserIsSubscribes();


          if (isPreSub) {
            yield IapSubscriptionStatusCheckedState(isSubscribedEnded: true);
          } else {
            yield IapSubscriptionStatusCheckedState(isSubscribedEnded: false);
          }
          await iapSubscriptionRepository.setUserIsSubscribes(false);

        }
      } catch (e) {
        yield IapSubscriptionStatusCheckingErrorState(
          error: e.toString(),
        );
      }
    }
  }
}
