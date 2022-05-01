import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/ethio_telecom_purchase_repository.dart';

part 'ethio_telecom_payment_event.dart';
part 'ethio_telecom_payment_state.dart';

class EthioTelecomPaymentBloc
    extends Bloc<EthioTelecomPaymentEvent, EthioTelecomPaymentState> {
  EthioTelecomPaymentBloc({required this.ethioTelecomPurchaseRepository})
      : super(EthioTelecomPaymentInitial());

  final EthioTelecomPurchaseRepository ethioTelecomPurchaseRepository;

  @override
  Stream<EthioTelecomPaymentState> mapEventToState(
      EthioTelecomPaymentEvent event) async* {
    if (event is StartEthioTelecomPaymentEvent) {
      yield EthioTelecomPurchasingState();

      try {
        ///CHECK IF INTERNET CONNECT IS AVAILABLE
        bool isNetAvailable =
            await ethioTelecomPurchaseRepository.checkInternetConnection();
        if (isNetAvailable) {
          ///SAVE LAST ITEM TO BE PURCHASED
          ethioTelecomPurchaseRepository.purchaseItem(
            event.itemId,
            event.appPurchasedItemType,
          );
        } else {
          ///NO INTERNET
          yield EthioTelecomPurchaseNoInternetState(dateTime: DateTime.now());
        }
      } catch (error) {
        yield EthioTelecomPurchasingFailedState(
          error: error.toString(),
          dateTime: DateTime.now(),
        );
      }

      //EthioTelecomPurchasingState
      // EthioTelecomPurchasedState
      // EthioTelecomPurchaseBalanceNotEnoughState
      //EthioTelecomPurchaseNoInternetState
      //EthioTelecomPurchasingFailedState

    }
  }
}
