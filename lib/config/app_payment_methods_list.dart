import 'dart:io';

import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/data/models/payment/payment_method_image.dart';

import 'constants.dart';

class AppPaymentMethodsList {
  static List<PaymentMethod> list = [
    PaymentMethod(
      appPaymentMethods: AppPaymentMethods.METHOD_TELEBIRR,
      isSelected: false,
      title: AppLocale.of().payWithTelebirr,
      isAvailable: true,
      description: AppLocale.of().payWithTelebirrMsg,
      paymentMethodImage: PaymentMethodImage(
        imagePath: AppAssets.icTelebirr,
        height: AppIconSizes.icon_size_36,
      ),
      paymentOptionImages: [],
    ),
    PaymentMethod(
      appPaymentMethods: AppPaymentMethods.METHOD_YENEPAY,
      isSelected: false,
      title: AppLocale.of().payWithYenepay,
      isAvailable: true,
      description: AppLocale.of().payWithYenepayMsg,
      paymentMethodImage: PaymentMethodImage(
        imagePath: AppAssets.icYenepay,
        height: AppIconSizes.icon_size_32,
      ),
      paymentOptionImages: [
        PaymentMethodImage(
          imagePath: AppAssets.icAmole,
          height: AppIconSizes.icon_size_20,
        ),
        PaymentMethodImage(
          imagePath: AppAssets.icCbe,
          height: AppIconSizes.icon_size_20,
        ),
        PaymentMethodImage(
          imagePath: AppAssets.icHelloCash,
          height: AppIconSizes.icon_size_24,
        ),
        PaymentMethodImage(
          imagePath: AppAssets.icMbirr,
          height: AppIconSizes.icon_size_24,
        ),
      ],
    ),
    PaymentMethod(
      appPaymentMethods: AppPaymentMethods.METHOD_INAPP,
      isSelected: false,
      isAvailable: true,
      title: Platform.isAndroid
          ? AppLocale.of().payWithGoogleplayInappPurchases
          : AppLocale.of().payWithAppStoreInappPurchases,
      description: Platform.isAndroid
          ? AppLocale.of().payWithGoogleplayInappPurchasesMsg
          : AppLocale.of().payWithAppStoreInappPurchasesMsg,
      paymentMethodImage: PaymentMethodImage(
        imagePath: Platform.isAndroid
            ? AppAssets.icGooglePlay
            : AppAssets.icAppleStore,
        height: AppIconSizes.icon_size_32,
      ),
      paymentOptionImages: [
        PaymentMethodImage(
          imagePath: AppAssets.icVisa,
          height: AppIconSizes.icon_size_16,
        ),
        PaymentMethodImage(
          imagePath: AppAssets.icMasterCard,
          height: AppIconSizes.icon_size_16,
        ),
        PaymentMethodImage(
          imagePath: AppAssets.icPaypal,
          height: AppIconSizes.icon_size_16,
        ),
        PaymentMethodImage(
          imagePath:
              Platform.isAndroid ? AppAssets.icGooglePay : AppAssets.icApplePay,
          height: AppIconSizes.icon_size_16,
        ),
      ],
    ),
  ];
}
