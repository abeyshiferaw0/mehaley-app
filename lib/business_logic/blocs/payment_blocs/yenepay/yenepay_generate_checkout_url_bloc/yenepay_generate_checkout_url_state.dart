part of 'yenepay_generate_checkout_url_bloc.dart';

abstract class YenepayGenerateCheckoutUrlState extends Equatable {
  const YenepayGenerateCheckoutUrlState();
}

class YenepayGenerateCheckoutUrlInitial
    extends YenepayGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class YenepayCheckoutUrlGeneratingState
    extends YenepayGenerateCheckoutUrlState {
  @override
  List<Object> get props => [];
}

class YenepayCheckoutUrlGeneratingErrorState
    extends YenepayGenerateCheckoutUrlState {
  final String error;

  YenepayCheckoutUrlGeneratingErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class YenepayCheckoutUrlGeneratedState extends YenepayGenerateCheckoutUrlState {
  final String checkoutUrl;

  YenepayCheckoutUrlGeneratedState({required this.checkoutUrl});

  @override
  List<Object> get props => [checkoutUrl];
}
