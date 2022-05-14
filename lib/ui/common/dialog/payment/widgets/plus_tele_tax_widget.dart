import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:sizer/sizer.dart';

class TeleTaxAddOnWidget extends StatelessWidget {
  const TeleTaxAddOnWidget({Key? key, required this.paymentMethod})
      : super(key: key);

  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return paymentMethod.appPaymentMethods == AppPaymentMethods.METHOD_TELE_CARD
        ? Tooltip(
            message: AppLocale.of().teleCutMsg,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: Duration(seconds: 2),
            waitDuration: Duration(seconds: 2),
            child: Container(
              padding: EdgeInsets.all(AppPadding.padding_6),
              child: Text(
                AppLocale.of().teleCutMsg.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_6.sp,
                  color: AppColors.darkOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
