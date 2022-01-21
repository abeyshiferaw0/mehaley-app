part of 'complete_purchase_bloc.dart';

abstract class CompletePurchaseState extends Equatable {
  const CompletePurchaseState();
}

class CompletePurchaseInitial extends CompletePurchaseState {
  @override
  List<Object> get props => [];
}

class PaymentMethodsLoadedState extends CompletePurchaseState {
  final List<PaymentMethod> availableMethods;

  PaymentMethodsLoadedState({required this.availableMethods});

  @override
  List<Object> get props => [availableMethods];
}
