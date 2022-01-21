part of 'complete_purchase_bloc.dart';

abstract class CompletePurchaseEvent extends Equatable {
  const CompletePurchaseEvent();
}

class LoadPaymentMethodsEvent extends CompletePurchaseEvent {
  const LoadPaymentMethodsEvent();

  @override
  List<Object?> get props => [];
}

class SelectedPaymentMethodChangedEvent extends CompletePurchaseEvent {
  const SelectedPaymentMethodChangedEvent({required this.paymentMethod});

  final PaymentMethod paymentMethod;

  @override
  List<Object?> get props => [paymentMethod];
}
