import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/app_payment_methods_list.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/payment_provider.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class PaymentRepository {
  //INIT PROVIDER FOR API CALL
  final PaymentProvider paymentProvider;

  const PaymentRepository({required this.paymentProvider});

  Future<AppPaymentMethods> setPreferredPaymentMethod(
      AppPaymentMethods appPaymentMethod) async {
    await AppHiveBoxes.instance.settingsBox.put(
      AppValues.preferredPaymentMethodKey,
      appPaymentMethod,
    );
    return AppHiveBoxes.instance.settingsBox
        .get(AppValues.preferredPaymentMethodKey);
  }

  AppPaymentMethods getPreferredPaymentMethod() {
    if (AppHiveBoxes.instance.settingsBox
        .containsKey(AppValues.preferredPaymentMethodKey)) {
      return AppHiveBoxes.instance.settingsBox
          .get(AppValues.preferredPaymentMethodKey);
    } else {
      return AppPaymentMethods.METHOD_UNK;
    }
  }

  List<PaymentMethod> getPaymentList() {
    List<PaymentMethod> list = [];
    AppPaymentMethods preferredPaymentMethod = getPreferredPaymentMethod();

    AppPaymentMethodsList.list.forEach((element) {
      PaymentMethod paymentMethod = element;

      ///CHECK IF PREFERRED
      if (element.appPaymentMethods == preferredPaymentMethod) {
        paymentMethod = paymentMethod.copyWith(
          isSelected: true,
        );
      }

      ///IF IN APP CHECK AVAILABILITY
      paymentMethod = checkIapAvailability(paymentMethod);

      ///IF ETHIO TELE CARD CHECK AVAILABILITY
      paymentMethod = checkEthioTeleCardAvailability(paymentMethod);

      list.add(paymentMethod);
    });
    return list;
  }

  PaymentMethod? getSelectedPreferredPaymentMethod() {
    AppPaymentMethods preferredPaymentMethod = getPreferredPaymentMethod();
    PaymentMethod? method;
    AppPaymentMethodsList.list.forEach((element) {
      if (element.appPaymentMethods == preferredPaymentMethod) {
        method = element;

        ///IF IN APP CHECK AVAILABILITY
        method = checkIapAvailability(method!);

        ///IF ETHIO TELE CARD CHECK AVAILABILITY
        method = checkEthioTeleCardAvailability(method!);
      }
    });
    return method;
  }

  List<PaymentMethod> getPaymentListWithSelected(PaymentMethod selected) {
    List<PaymentMethod> list = [];

    AppPaymentMethodsList.list.forEach((element) {
      PaymentMethod paymentMethod = element;

      ///IF IN APP CHECK AVAILABILITY
      paymentMethod = checkIapAvailability(paymentMethod);

      ///IF ETHIO TELE CARD CHECK AVAILABILITY
      paymentMethod = checkEthioTeleCardAvailability(paymentMethod);

      list.add(
        paymentMethod.copyWith(
          isSelected:
              paymentMethod.appPaymentMethods == selected.appPaymentMethods
                  ? true
                  : false,
        ),
      );
    });
    return list;
  }

  PaymentMethod checkIapAvailability(PaymentMethod paymentMethod) {
    if (paymentMethod.appPaymentMethods == AppPaymentMethods.METHOD_INAPP) {
      if (PagesUtilFunctions.isIapAvailable()) {
        return paymentMethod.copyWith(
          isAvailable: true,
        );
      } else {
        return paymentMethod.copyWith(
          isAvailable: false,
          isSelected: false,
        );
      }
    }

    return paymentMethod;
  }

  PaymentMethod checkEthioTeleCardAvailability(PaymentMethod paymentMethod) {
    if (paymentMethod.appPaymentMethods == AppPaymentMethods.METHOD_TELE_CARD) {
      if (AuthUtil.isUserPhoneAuthenticated() &&
          !AuthUtil.isUserPhoneEthiopian()) {
        return paymentMethod.copyWith(
          isAvailable: false,
          isSelected: false,
        );
      } else {
        return paymentMethod.copyWith(
          isAvailable: true,
        );
      }
    }

    return paymentMethod;
  }

  cancelDio() {
    paymentProvider.cancel();
  }
}
