import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/payment/ethio_tele_subscription_offerings.dart';
import 'package:mehaley/data/repositories/ethio_telecom_subscription_repository.dart';

part 'ethio_telecom_subscription_event.dart';

part 'ethio_telecom_subscription_state.dart';

class EthioTelecomSubscriptionBloc
    extends Bloc<EthioTelecomSubscriptionEvent, EthioTelecomSubscriptionState> {
  EthioTelecomSubscriptionBloc(
      {required this.ethioTelecomSubscriptionRepository})
      : super(EthioTelecomSubscriptionInitial());

  final EthioTelecomSubscriptionRepository ethioTelecomSubscriptionRepository;

  @override
  Stream<EthioTelecomSubscriptionState> mapEventToState(
      EthioTelecomSubscriptionEvent event) async* {
    if (event is LoadEthioTeleSubscriptionOfferingsEvent) {
      yield EthioTeleSubscriptionLoadingState();
      try {
        List<EthioTeleSubscriptionOfferings> ethioTeleSubscriptionOfferings =
            await ethioTelecomSubscriptionRepository
                .getEthioTeleSubscriptionOfferings(
          AppCacheStrategy.LOAD_CACHE_FIRST,
        );

        yield EthioTeleSubscriptionLoadedState(
          ethioTeleSubscriptionOfferings: ethioTeleSubscriptionOfferings,
        );
      } catch (error) {
        print("errorerror=> ${error}");
        yield EthioTeleSubscriptionLoadingErrorState(
          error: error.toString(),
          dateTime: DateTime.now(),
        );
      }
    }
  }
}
