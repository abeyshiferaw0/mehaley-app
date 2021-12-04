import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogBillConfirmed extends StatelessWidget {
  const DialogBillConfirmed({Key? key, required this.freshBill})
      : super(key: key);

  final WebirrBill freshBill;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Material(
            child: Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.9,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(AppPadding.padding_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    AppAssets.successLottie,
                    width: ScreenUtil(context: context).getScreenWidth() * 0.4,
                    height: ScreenUtil(context: context).getScreenWidth() * 0.4,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  buildSuccessMsg(),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  buildPaymentDetails(),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  buildCloseButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuccessMsg() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of().walletRechargedSuccessfully,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w500,
            color: ColorUtil.darken(AppColors.green, 0.09),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Text(
          AppLocale.of().walletRechargedSuccessfullyMsg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.txtGrey,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Divider(color: AppColors.lightGrey),
      ],
    );
  }

  Widget buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of().walletRechargedSuccessTransactionNumber(
            transactionNumber: freshBill.webirrPayment!.paymentReference,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.blue,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of().totalAmountPaid.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.txtGrey,
              ),
            ),
            Text(
              '${freshBill.amount.toStringAsFixed(2)} ${AppLocale.of().birr}'
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        Divider(color: AppColors.lightGrey),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of().paidUsing.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.txtGrey,
              ),
            ),
            Text(
              freshBill.webirrPayment!.paymentMethod.paymentMethodName
                  .replaceAll('_', ' ')
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        Divider(color: AppColors.lightGrey),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of().transactionDate.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.txtGrey,
              ),
            ),
            Text(
              DateFormat.yMMMMd()
                  .add_jm()
                  .format(freshBill.webirrPayment!.confirmedTime)
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        Divider(color: AppColors.lightGrey),
      ],
    );
  }

  Widget buildCloseButton(context) {
    return AppBouncingButton(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_12,
          vertical: AppPadding.padding_12,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppMargin.margin_16,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkOrange,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            AppLocale.of().close.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
