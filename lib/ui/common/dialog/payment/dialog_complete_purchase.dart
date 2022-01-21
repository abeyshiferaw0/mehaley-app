import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/complete_purchase_dialog_bloc/complete_purchase_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_payment_methods.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/dialog/widgets/payment_item.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogCompletePurchase extends StatefulWidget {
  const DialogCompletePurchase(
      {Key? key,
      required this.onYenepaySelected,
      required this.onTelebirrSelected,
      required this.onInAppSelected,
      required this.priceEtb})
      : super(key: key);

  final VoidCallback onYenepaySelected;
  final VoidCallback onTelebirrSelected;
  final VoidCallback onInAppSelected;
  final double priceEtb;

  @override
  State<DialogCompletePurchase> createState() => _DialogCompletePurchaseState();
}

class _DialogCompletePurchaseState extends State<DialogCompletePurchase> {
  ///
  late bool alwaysUseSelected;
  late PaymentMethod? selectedPaymentMethod;

  @override
  void initState() {
    alwaysUseSelected = false;
    selectedPaymentMethod = null;
    BlocProvider.of<CompletePurchaseBloc>(context).add(
      LoadPaymentMethodsEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompletePurchaseBloc, CompletePurchaseState>(
      listener: (context, state) {
        if (state is PaymentMethodsLoadedState) {
          state.availableMethods.forEach((e) {
            if (e.isSelected) {
              setState(() {
                selectedPaymentMethod = e;
              });
            }
          });
        }
      },
      child: Center(
        child: Wrap(
          children: [
            Container(
              height: ScreenUtil(context: context).getScreenHeight() * 0.8,
              margin: EdgeInsets.symmetric(
                horizontal: AppMargin.margin_16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.all(
                AppPadding.padding_16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDialogHeader(context),
                  Expanded(
                    child: BlocBuilder<CompletePurchaseBloc,
                        CompletePurchaseState>(
                      builder: (context, state) {
                        if (state is PaymentMethodsLoadedState) {
                          return buildPaymentMethodsList(
                            state.availableMethods,
                          );
                        } else {
                          return AppLoading(
                            size: AppValues.loadingWidgetSize * 0.8,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  buildAlwaysSelectedCheckBox(),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  buildPayButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildAlwaysSelectedCheckBox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: AppColors.white,
          child: Checkbox(
            value: alwaysUseSelected,
            //activeColor: AppColors.darkOrange,
            fillColor: MaterialStateProperty.all(
              AppColors.darkOrange,
            ),
            checkColor: AppColors.white,
            onChanged: (bool? value) {
              setState(() {
                alwaysUseSelected = value == null ? false : value;
              });
            },
          ),
        ),
        Text(
          AppLocale.of().alwaysUsePayment,
          style: TextStyle(
            color: AppColors.txtGrey,
            fontWeight: FontWeight.w400,
            fontSize: AppFontSizes.font_size_8.sp,
          ),
        ),
      ],
    );
  }

  AppBouncingButton buildPayButton() {
    return AppBouncingButton(
      onTap: () {
        ///CALL APPROPRIATE PAYMENT UTIL METHOD BASED ON SELECTED PAYMENT TYPE
        if (selectedPaymentMethod != null) {
          if (selectedPaymentMethod!.isAvailable) {
            ///POP DIALOG
            Navigator.pop(context);
            if (selectedPaymentMethod!.appPaymentMethods ==
                AppPaymentMethods.METHOD_INAPP) {
              widget.onInAppSelected();
            }
            if (selectedPaymentMethod!.appPaymentMethods ==
                AppPaymentMethods.METHOD_TELEBIRR) {
              widget.onTelebirrSelected();
            }
            if (selectedPaymentMethod!.appPaymentMethods ==
                AppPaymentMethods.METHOD_YENEPAY) {
              widget.onYenepaySelected();
            }

            ///IF USE ALWAYS SELECTED SET PREFERRED PAYMENT TYPE
            if (alwaysUseSelected) {
              BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
                SetPreferredPaymentMethodEvent(
                  appPaymentMethods: selectedPaymentMethod!.appPaymentMethods,
                ),
              );
            }
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_32,
          vertical: AppPadding.padding_16,
        ),
        decoration: BoxDecoration(
          color: selectedPaymentMethod != null
              ? selectedPaymentMethod!.isAvailable
                  ? AppColors.darkOrange
                  : AppColors.darkGrey
              : AppColors.darkGrey,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().buy.toUpperCase(),
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_10.sp,
              ),
            ),
            SizedBox(
              width: AppPadding.padding_8,
            ),
            Icon(
              FlutterRemix.arrow_right_s_line,
              color: AppColors.white,
              size: AppIconSizes.icon_size_20,
            ),
          ],
        ),
      ),
    );
  }

  ListView buildPaymentMethodsList(List<PaymentMethod> availableMethods) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: availableMethods.length,
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_16),
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: AppMargin.margin_20,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return PaymentMethodItem(
          paymentMethod: availableMethods.elementAt(index),
          onTap: () {
            BlocProvider.of<CompletePurchaseBloc>(context).add(
              SelectedPaymentMethodChangedEvent(
                paymentMethod: availableMethods.elementAt(index),
              ),
            );
          },
        );
      },
    );
  }

  Column buildDialogHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppLocale.of().chooseYourPaymentMethod,
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: AppFontSizes.font_size_12.sp,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppBouncingButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  FlutterRemix.close_line,
                  color: AppColors.black,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_4,
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
          child: Text(
            AppLocale.of().chooseYourPaymentMethodMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.txtGrey,
              fontWeight: FontWeight.w400,
              fontSize: AppFontSizes.font_size_8.sp,
            ),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
      ],
    );
  }
}
