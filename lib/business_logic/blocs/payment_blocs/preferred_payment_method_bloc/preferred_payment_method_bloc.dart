import 'package:bloc/bloc.dart';
import 'package:elf_play/data/models/enums/app_payment_methods.dart';
import 'package:elf_play/data/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';

part 'preferred_payment_method_event.dart';
part 'preferred_payment_method_state.dart';

class PreferredPaymentMethodBloc
    extends Bloc<PreferredPaymentMethodEvent, PreferredPaymentMethodState> {
  PreferredPaymentMethodBloc({required this.paymentRepository})
      : super(PreferredPaymentMethodInitial());

  final PaymentRepository paymentRepository;

  @override
  Stream<PreferredPaymentMethodState> mapEventToState(
      PreferredPaymentMethodEvent event) async* {
    if (event is SetPreferredPaymentMethodEvent) {
      yield PreferredPaymentMethodInitial();
      AppPaymentMethods appPaymentMethod =
          paymentRepository.setPreferredPaymentMethod(event.appPaymentMethods);
      yield PreferredPaymentMethodChangedState(
          appPaymentMethod: event.appPaymentMethods);
      yield PreferredPaymentMethodLoadedState(
          appPaymentMethod: appPaymentMethod);
    } else if (event is LoadPreferredPaymentMethodEvent) {
      yield PreferredPaymentMethodInitial();
      AppPaymentMethods appPaymentMethod =
          paymentRepository.getPreferredPaymentMethod();
      yield PreferredPaymentMethodLoadedState(
          appPaymentMethod: appPaymentMethod);
    }
  }
}
