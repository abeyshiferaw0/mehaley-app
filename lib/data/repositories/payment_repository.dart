import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/data_providers/payment_provider.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
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
      if (element.appPaymentMethods == AppPaymentMethods.METHOD_INAPP) {
        if (PagesUtilFunctions.isIapAvailable()) {
          paymentMethod = paymentMethod.copyWith(
            isAvailable: true,
          );
        } else {
          paymentMethod = paymentMethod.copyWith(
            isAvailable: false,
          );
        }
      }
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
        if (method!.appPaymentMethods == AppPaymentMethods.METHOD_INAPP) {
          if (PagesUtilFunctions.isIapAvailable()) {
            method = method!.copyWith(
              isAvailable: true,
            );
          } else {
            method = method!.copyWith(
              isAvailable: false,
            );
          }
        }
      }
    });
    return method;
  }

  List<PaymentMethod> getPaymentListWithSelected(PaymentMethod selected) {
    List<PaymentMethod> list = [];

    AppPaymentMethodsList.list.forEach((element) {
      PaymentMethod paymentMethod = element;

      ///IF IN APP CHECK AVAILABILITY
      if (paymentMethod.appPaymentMethods == AppPaymentMethods.METHOD_INAPP) {
        if (PagesUtilFunctions.isIapAvailable()) {
          paymentMethod = paymentMethod.copyWith(
            isAvailable: true,
          );
        } else {
          paymentMethod = paymentMethod.copyWith(
            isAvailable: false,
          );
        }
      }
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

  cancelDio() {
    paymentProvider.cancel();
  }
}
