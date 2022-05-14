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

      ///GET LOCAL AND FOREIGN METHODS FROM AVALVABLE LIST
      List<PaymentMethod> localAvailableMethods =
          getLocalMethods(availableMethods);
      List<PaymentMethod> foreignAvailableMethods =
          getForeignAvailableMethods(availableMethods);

      yield PaymentMethodsLoadedState(
        availableMethods: availableMethods,
        localAvailableMethods: localAvailableMethods,
        foreignAvailableMethods: foreignAvailableMethods,
      );
    } else if (event is SelectedPaymentMethodChangedEvent) {
      yield CompletePurchaseInitial();
      List<PaymentMethod> availableMethods =
          paymentRepository.getPaymentListWithSelected(
        event.paymentMethod,
      );

      ///GET LOCAL AND FOREIGN METHODS FROM AVALVABLE LIST
      List<PaymentMethod> localAvailableMethods =
          getLocalMethods(availableMethods);
      List<PaymentMethod> foreignAvailableMethods =
          getForeignAvailableMethods(availableMethods);

      yield PaymentMethodsLoadedState(
        availableMethods: availableMethods,
        localAvailableMethods: localAvailableMethods,
        foreignAvailableMethods: foreignAvailableMethods,
      );
    }
  }

  List<PaymentMethod> getLocalMethods(List<PaymentMethod> availableMethods) {
    List<PaymentMethod> m = [];
    availableMethods.forEach((element) {
      if (element.isLocal) m.add(element);
    });
    return m;
  }

  List<PaymentMethod> getForeignAvailableMethods(
      List<PaymentMethod> availableMethods) {
    List<PaymentMethod> m = [];
    availableMethods.forEach((element) {
      if (!element.isLocal) m.add(element);
    });
    return m;
  }
}
