import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/data_providers/payment_provider.dart';
import 'package:elf_play/data/models/enums/app_payment_methods.dart';

class PaymentRepository {
  //INIT PROVIDER FOR API CALL
  final PaymentProvider paymentProvider;

  const PaymentRepository({required this.paymentProvider});

  AppPaymentMethods setPreferredPaymentMethod(
      AppPaymentMethods appPaymentMethod) {
    AppHiveBoxes.instance.settingsBox.put(
      AppValues.preferredPaymentMethodKey,
      appPaymentMethod,
    );
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  AppPaymentMethods getPreferredPaymentMethod() {
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  cancelDio() {
    paymentProvider.cancel();
  }
}
