part of 'preferred_payment_method_bloc.dart';

abstract class PreferredPaymentMethodEvent extends Equatable {
  const PreferredPaymentMethodEvent();
}

class SetPreferredPaymentMethodEvent extends PreferredPaymentMethodEvent {
  final AppPaymentMethods appPaymentMethods;

  SetPreferredPaymentMethodEvent({required this.appPaymentMethods});

  @override
  List<Object?> get props => [appPaymentMethods];
}

class LoadPreferredPaymentMethodEvent extends PreferredPaymentMethodEvent {
  LoadPreferredPaymentMethodEvent();

  @override
  List<Object?> get props => [];
}
