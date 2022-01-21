import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/data/repositories/payment_repository.dart';

part 'complete_purchase_event.dart';
part 'complete_purchase_state.dart';

class CompletePurchaseBloc
    extends Bloc<CompletePurchaseEvent, CompletePurchaseState> {
  CompletePurchaseBloc({required this.paymentRepository})
      : super(CompletePurchaseInitial());

  final PaymentRepository paymentRepository;

  @override
  Stream<CompletePurchaseState> mapEventToState(
      CompletePurchaseEvent event) async* {
    if (event is LoadPaymentMethodsEvent) {
      yield CompletePurchaseInitial();
      List<PaymentMethod> availableMethods = paymentRepository.getPaymentList();
      yield PaymentMethodsLoadedState(
        availableMethods: availableMethods,
      );
    } else if (event is SelectedPaymentMethodChangedEvent) {
      yield CompletePurchaseInitial();
      List<PaymentMethod> availableMethods =
          paymentRepository.getPaymentListWithSelected(
        event.paymentMethod,
      );
      yield PaymentMethodsLoadedState(
        availableMethods: availableMethods,
      );
    }
  }
}
