import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/data/repositories/payment_repository.dart';

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

      ///SET PAYMENT METHODS THE RELOAD
      await paymentRepository
          .setPreferredPaymentMethod(event.appPaymentMethods);

      List<PaymentMethod> availableMethods = paymentRepository.getPaymentList();
      yield PreferredPaymentMethodLoadedState(
        availableMethods: availableMethods,
      );
    } else if (event is LoadPreferredPaymentMethodEvent) {
      yield PreferredPaymentMethodInitial();
      List<PaymentMethod> availableMethods = paymentRepository.getPaymentList();
      yield PreferredPaymentMethodLoadedState(
        availableMethods: availableMethods,
      );
    }
  }
}
