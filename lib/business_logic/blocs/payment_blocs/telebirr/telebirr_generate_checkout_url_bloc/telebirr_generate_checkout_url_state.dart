part of 'telebirr_generate_checkout_url_bloc.dart';

abstract class TelebirrGenerateCheckoutUrlState extends Equatable {
  const TelebirrGenerateCheckoutUrlState();
}

class TelebirrGenerateCheckoutUrlInitial
    extends TelebirrGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class TelebirrCheckoutUrlGeneratingState
    extends TelebirrGenerateCheckoutUrlInitial {
  @override
  List<Object> get props => [];
}

class TelebirrCheckoutUrlGeneratingErrorState
    extends TelebirrGenerateCheckoutUrlInitial {
  final String error;

  TelebirrCheckoutUrlGeneratingErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class TelebirrCheckoutUrlGeneratedState
    extends TelebirrGenerateCheckoutUrlInitial {
  final String checkoutUrl;

  TelebirrCheckoutUrlGeneratedState({required this.checkoutUrl});

  @override
  List<Object> get props => [checkoutUrl];
}
