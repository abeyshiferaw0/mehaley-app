import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/tele_payment_result_data.dart';
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
        TelePaymentResultData telePaymentResultData =
            await ethioTelecomPurchaseRepository.purchaseItem(
          event.itemId,
          event.purchasedItemType,
        );

        if (telePaymentResultData.paymentErrorResult != null) {
          ///IF NORMAL RESULT IS NOT NULL CHECK FOR IS_FREE OR IS_ALREADY_BOUGHT VALUES
          if (telePaymentResultData.paymentErrorResult!.isFree) {
            yield EthioTelecomPurchasedIsFreeState(
              itemId: event.itemId,
              purchasedItemType: event.purchasedItemType,
              telePaymentResultData: telePaymentResultData,
            );
          }

          if (telePaymentResultData.paymentErrorResult!.isAlreadyBought) {
            yield EthioTelecomIsAlreadyBoughtState(
              itemId: event.itemId,
              purchasedItemType: event.purchasedItemType,
              telePaymentResultData: telePaymentResultData,
            );
          }
        } else if (telePaymentResultData.teleResult != null) {
          ///IF TELE RESULT IS NOT NULL CHECK FOR SUCCESS OR
          /// FAILURE (MIGHT BE BALANCE NOT ENOUGH)
          if (telePaymentResultData.teleResult!.status) {
            yield EthioTelecomPurchasedSuccessState(
              itemId: event.itemId,
              purchasedItemType: event.purchasedItemType,
              telePaymentResultData: telePaymentResultData,
            );
          } else {
            if (telePaymentResultData.teleResult!.isBalanceNotEnough) {
              yield EthioTelecomPurchaseBalanceNotEnoughState(
                itemId: event.itemId,
                purchasedItemType: event.purchasedItemType,
                telePaymentResultData: telePaymentResultData,
              );
            } else {
              yield EthioTelecomPurchaseNotSuccessState(
                itemId: event.itemId,
                purchasedItemType: event.purchasedItemType,
                telePaymentResultData: telePaymentResultData,
              );
            }
          }
        } else {
          throw 'TELE CARD PURCHASE RESULT NOT VALID';
        }
      } catch (error) {
        yield EthioTelecomPurchasingFailedState(
          error: error.toString(),
          dateTime: DateTime.now(),
        );
      }
    }
  }
}
