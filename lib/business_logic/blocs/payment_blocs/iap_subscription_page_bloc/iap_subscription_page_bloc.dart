import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/data/repositories/iap_subscription_repository.dart';

part 'iap_subscription_page_event.dart';
part 'iap_subscription_page_state.dart';

class IapSubscriptionPageBloc
    extends Bloc<IapSubscriptionPageEvent, IapSubscriptionPageState> {
  IapSubscriptionPageBloc({required this.iapSubscriptionRepository})
      : super(IapSubscriptionInitial());

  final IapSubscriptionRepository iapSubscriptionRepository;

  @override
  Stream<IapSubscriptionPageState> mapEventToState(
      IapSubscriptionPageEvent event) async* {
    if (event is LoadIapSubscriptionOfferingsEvent) {
      yield IapSubscriptionLoadingState();

      try {
        List<SubscriptionOfferings> subscriptionOfferingsList =
            await iapSubscriptionRepository.fetchOfferings();

        yield IapSubscriptionLoadedState(
          subscriptionOfferingsList: subscriptionOfferingsList,
        );
      } catch (e) {
        if (e is PlatformException) {
          if (e.code == '3') {
            yield IapNotAvailableErrorState();
          } else {
            yield IapSubscriptionLoadingErrorState(
              error: e.toString(),
            );
          }
        } else {
          yield IapSubscriptionLoadingErrorState(
            error: e.toString(),
          );
        }
      }
    }
  }
}
