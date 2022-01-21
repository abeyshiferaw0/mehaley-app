part of 'preferred_payment_method_bloc.dart';

abstract class PreferredPaymentMethodState extends Equatable {
  const PreferredPaymentMethodState();
}

class PreferredPaymentMethodInitial extends PreferredPaymentMethodState {
  @override
  List<Object> get props => [];
}

class PreferredPaymentMethodChangedState extends PreferredPaymentMethodState {
  final AppPaymentMethods appPaymentMethod;

  PreferredPaymentMethodChangedState({required this.appPaymentMethod});

  @override
  List<Object> get props => [appPaymentMethod];
}

class PreferredPaymentMethodLoadedState extends PreferredPaymentMethodState {
  final List<PaymentMethod> availableMethods;

  PreferredPaymentMethodLoadedState({required this.availableMethods});

  @override
  List<Object> get props => [availableMethods];
}
