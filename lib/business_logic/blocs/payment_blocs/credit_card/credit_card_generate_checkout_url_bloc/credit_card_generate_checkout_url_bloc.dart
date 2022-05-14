import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/credit_card_check_out_api_result_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/credit_card_purchase_repository.dart';

part 'credit_card_generate_checkout_url_event.dart';
part 'credit_card_generate_checkout_url_state.dart';

class CreditCardGenerateCheckoutUrlBloc extends Bloc<
    CreditCardGenerateCheckoutUrlEvent, CreditCardGenerateCheckoutUrlState> {
  CreditCardGenerateCheckoutUrlBloc(
      {required this.creditCardPurchaseRepository})
      : super(CreditCardGenerateCheckoutUrlInitial());

  final CreditCardPurchaseRepository creditCardPurchaseRepository;

  @override
  Stream<CreditCardGenerateCheckoutUrlState> mapEventToState(
      CreditCardGenerateCheckoutUrlEvent event) async* {
    if (event is GenerateCheckoutUrlEvent) {
      // //////////////////////////////////////////////////////
      // //////////////////////////////////////////////////////
      // yield CreditCardCheckoutUrlGeneratingState();
      //
      // // CreditCardCheckoutUrlGeneratingState
      // // CreditCardCheckIsFreeState
      // // CreditCardCheckIsFreeState
      // // CreditCardCheckIsAlreadyBoughtState
      // // CreditCardCheckoutUrlGeneratedState
      // // CreditCardCheckoutUrlGeneratingErrorState
      //
      // yield CreditCardCheckoutUrlGeneratedState(
      //     creditCardResult: CreditCardResult(
      //       signature: 'PEwWgHThMyGhMoKWIZhC677Ua+fZHZ6tH4CX0CLZpCg=',
      //       signedFieldNames:
      //           'access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency',
      //       amount: '100.00',
      //       profileId: '6A77A547-2CDD-40C9-BB8D-35C9F14C1D8C',
      //       transactionType: 'authorization',
      //       signedDateTime: '2022-05-08T13:40:21Z',
      //       currency: 'USD',
      //       unsignedFieldNames: '',
      //       referenceNumber: '1652019000046',
      //       transactionUuid: '16277c84592e02',
      //       accessKey: 'fc86841e1a49398394b8e8976562450a',
      //       locale: 'en',
      //     ),
      //     checkOutUrl:
      //         "https://testsecureacceptance.cybersource.com/embedded/pay");
      // //////////////////////////////////////////////////////
      // //////////////////////////////////////////////////////

      yield CreditCardCheckoutUrlGeneratingState();
      try {
        ///GENERATE CreditCard CHECKOUT URL
        final CreditCardCheckOutApiResult creditCardCheckOutApiResult =
            await creditCardPurchaseRepository.generateCheckoutUrl(
          event.itemId,
          event.purchasedItemType,
        );

        ///CHECK FOR BACK END PAYMENT ERROR FIRST LIKE (IS_FREE OR EXISTS)
        if (creditCardCheckOutApiResult.paymentErrorResult != null) {
          if (creditCardCheckOutApiResult.paymentErrorResult!.isFree) {
            yield CreditCardCheckIsFreeState();
          } else if (creditCardCheckOutApiResult
              .paymentErrorResult!.isAlreadyBought) {
            yield CreditCardCheckIsAlreadyBoughtState();
          } else {
            throw 'CREDIT CARD GENERATE URL PAYMENT ERROR RESPONSE NOT VALID';
          }
        } else if (creditCardCheckOutApiResult.creditCardResult != null &&
            creditCardCheckOutApiResult.paymentUrl != null) {
          ///IF CHECKOUT URL IS GENERATED SHOW CYBERSOURCE PAYMENT DIALOG
          yield CreditCardCheckoutUrlGeneratedState(
            creditCardResult: creditCardCheckOutApiResult.creditCardResult!,
            checkOutUrl: creditCardCheckOutApiResult.paymentUrl!,
          );
        } else {
          throw 'CREDIT CARD GENERATE URL RESPONSE NOT VALID';
        }
      } catch (e) {
        yield CreditCardCheckoutUrlGeneratingErrorState(error: e.toString());
      }
    }
  }
}
