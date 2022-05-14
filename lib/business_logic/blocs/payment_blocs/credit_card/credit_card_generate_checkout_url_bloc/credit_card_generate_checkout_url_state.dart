part of 'credit_card_generate_checkout_url_bloc.dart';

abstract class CreditCardGenerateCheckoutUrlState extends Equatable {
  const CreditCardGenerateCheckoutUrlState();
}

class CreditCardGenerateCheckoutUrlInitial
    extends CreditCardGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class CreditCardCheckoutUrlGeneratingState
    extends CreditCardGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class CreditCardCheckIsFreeState extends CreditCardGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class CreditCardCheckIsAlreadyBoughtState
    extends CreditCardGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class CreditCardCheckoutUrlGeneratingErrorState
    extends CreditCardGenerateCheckoutUrlState {
  final String error;

  CreditCardCheckoutUrlGeneratingErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class CreditCardCheckoutUrlGeneratedState
    extends CreditCardGenerateCheckoutUrlState {
  final CreditCardResult creditCardResult;
  final String checkOutUrl;

  CreditCardCheckoutUrlGeneratedState({
    required this.checkOutUrl,
    required this.creditCardResult,
  });

  @override
  List<Object> get props => [
        creditCardResult,
        checkOutUrl,
      ];
}
