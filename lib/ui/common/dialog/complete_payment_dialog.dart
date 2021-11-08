import 'package:elf_play/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/enums/app_payment_methods.dart';
import 'package:elf_play/ui/common/dialog/widgets/payment_item.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';
import '../small_text_price_widget.dart';

class CompletePaymentDialog extends StatefulWidget {
  const CompletePaymentDialog({Key? key}) : super(key: key);

  @override
  State<CompletePaymentDialog> createState() => _CompletePaymentDialogState();
}

class _CompletePaymentDialogState extends State<CompletePaymentDialog> {
  late AppPaymentMethods selectedAppPaymentMethods;
  late AppPaymentMethods preferredAppPaymentMethods;
  late bool alwaysUseSelected;

  @override
  void initState() {
    selectedAppPaymentMethods = AppPaymentMethods.METHOD_UNK;
    preferredAppPaymentMethods = AppPaymentMethods.METHOD_UNK;
    alwaysUseSelected = false;
    BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
      LoadPreferredPaymentMethodEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
            child: BlocBuilder<PreferredPaymentMethodBloc, PreferredPaymentMethodState>(
              builder: (context, state) {
                if (state is PreferredPaymentMethodLoadedState) {
                  ///SET PREFERRED PAYMENT METHOD
                  preferredAppPaymentMethods = state.appPaymentMethod;

                  ///SET ALWAYS SELECTED CHECK BOX TO TRUE IF PREFERRED SELECTED
                  if (preferredAppPaymentMethods != AppPaymentMethods.METHOD_UNK) {
                    alwaysUseSelected = true;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDialogHeader(context, state.appPaymentMethod),
                      SizedBox(
                        height: AppMargin.margin_8,
                      ),
                      buildPaymentMethodsList(),
                      SizedBox(
                        height: AppMargin.margin_20,
                      ),
                      buildAlwaysSelectedCheckBox(),
                      SizedBox(
                        height: AppMargin.margin_8,
                      ),
                      buildPayButton(),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Row buildAlwaysSelectedCheckBox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          child: Checkbox(
            value: alwaysUseSelected,
            activeColor: AppColors.darkGreen,
            fillColor: MaterialStateProperty.all(
              AppColors.darkGreen,
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
          AppLocalizations.of(context)!.alwaysUsePayment,
          style: TextStyle(
            color: AppColors.txtGrey,
            fontWeight: FontWeight.w400,
            fontSize: AppFontSizes.font_size_8.sp,
          ),
        ),
      ],
    );
  }

  AppBouncingButton buildPayButton() => AppBouncingButton(
        onTap: () {
          if (alwaysUseSelected) {
            if (getSelectedPayment() != AppPaymentMethods.METHOD_UNK) {
              BlocProvider.of<PreferredPaymentMethodBloc>(context).add(
                SetPreferredPaymentMethodEvent(
                  appPaymentMethods: getSelectedPayment(),
                ),
              );
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32,
            vertical: AppPadding.padding_16,
          ),
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.buy.toUpperCase(),
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
                PhosphorIcons.caret_right,
                color: AppColors.white,
                size: AppIconSizes.icon_size_20,
              ),
            ],
          ),
        ),
      );

  Expanded buildPaymentMethodsList() {
    return Expanded(
      child: ShaderMask(
        blendMode: BlendMode.dstOut,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              Colors.transparent,
              Colors.transparent,
              AppColors.white,
            ],
            stops: [0.0, 0.03, 0.98, 1.0],
          ).createShader(bounds);
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: AppLocalizations.of(context)!.amole,
                imagePath: 'assets/images/ic_amole.png',
                scale: 1.0,
                isSelected: isPaymentSelected(
                  AppPaymentMethods.METHOD_AMOLE,
                ),
                appPaymentMethods: AppPaymentMethods.METHOD_AMOLE,
                onTap: () {
                  setState(() {
                    selectedAppPaymentMethods = AppPaymentMethods.METHOD_AMOLE;
                  });
                },
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: AppLocalizations.of(context)!.cbeBirr,
                imagePath: 'assets/images/ic_cbe_birr.png',
                scale: 1.0,
                isSelected: isPaymentSelected(
                  AppPaymentMethods.METHOD_CBE_BIRR,
                ),
                appPaymentMethods: AppPaymentMethods.METHOD_CBE_BIRR,
                onTap: () {
                  setState(() {
                    selectedAppPaymentMethods = AppPaymentMethods.METHOD_CBE_BIRR;
                  });
                },
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: AppLocalizations.of(context)!.helloCash,
                imagePath: 'assets/images/ic_hello_cash.png',
                scale: 0.8,
                isSelected: isPaymentSelected(
                  AppPaymentMethods.METHOD_HELLO_CASH,
                ),
                appPaymentMethods: AppPaymentMethods.METHOD_HELLO_CASH,
                onTap: () {
                  setState(() {
                    selectedAppPaymentMethods = AppPaymentMethods.METHOD_HELLO_CASH;
                  });
                },
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: AppLocalizations.of(context)!.mbirr,
                imagePath: 'assets/images/ic_mbirr.png',
                scale: 1.3,
                isSelected: isPaymentSelected(
                  AppPaymentMethods.METHOD_MBIRR,
                ),
                appPaymentMethods: AppPaymentMethods.METHOD_MBIRR,
                onTap: () {
                  setState(() {
                    selectedAppPaymentMethods = AppPaymentMethods.METHOD_MBIRR;
                  });
                },
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: AppLocalizations.of(context)!.visa,
                imagePath: 'assets/images/ic_visa.png',
                scale: 1.0,
                isSelected: isPaymentSelected(
                  AppPaymentMethods.METHOD_VISA,
                ),
                appPaymentMethods: AppPaymentMethods.METHOD_VISA,
                onTap: () {
                  setState(() {
                    selectedAppPaymentMethods = AppPaymentMethods.METHOD_VISA;
                  });
                },
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              PaymentMethodItem(
                title: AppLocalizations.of(context)!.mastercard,
                imagePath: 'assets/images/ic_mastercard.png',
                scale: 1.0,
                isSelected: isPaymentSelected(
                  AppPaymentMethods.METHOD_MASTERCARD,
                ),
                appPaymentMethods: AppPaymentMethods.METHOD_MASTERCARD,
                onTap: () {
                  setState(() {
                    selectedAppPaymentMethods = AppPaymentMethods.METHOD_MASTERCARD;
                  });
                },
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildDialogHeader(BuildContext context, AppPaymentMethods appPaymentMethod) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!.completeYourPurchase,
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
                  PhosphorIcons.x_light,
                  color: AppColors.black,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.3,
              child: SmallTextPriceWidget(
                isFree: false,
                price: 23.0,
                isPurchased: false,
                discountPercentage: 0.1,
                isDiscountAvailable: true,
                appCurrency: getSelectedAppCurrency(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool isPaymentSelected(AppPaymentMethods appPaymentMethods) {
    ///FIRST USER USER NEWLY SELECTED
    if (selectedAppPaymentMethods == appPaymentMethods) {
      return true;
    }

    ///IF NOT NEWLY SELECTED PAYMENT BLOCK FROM CHECKING PREFERRED
    if (selectedAppPaymentMethods == AppPaymentMethods.METHOD_UNK) {
      ///LASTLY CHECK IF PREFERRED METHOD IS SET
      if (preferredAppPaymentMethods == appPaymentMethods) {
        return true;
      }
    } else {
      return false;
    }

    return false;
  }

  AppPaymentMethods getSelectedPayment() {
    ///FIRST USER USER NEWLY SELECTED
    if (selectedAppPaymentMethods != AppPaymentMethods.METHOD_UNK) {
      return selectedAppPaymentMethods;
    }

    ///IF NOT NEWLY SELECTED PAYMENT BLOCK FROM CHECKING PREFERRED
    if (selectedAppPaymentMethods == AppPaymentMethods.METHOD_UNK) {
      ///LASTLY CHECK IF PREFERRED METHOD IS SET
      if (preferredAppPaymentMethods != AppPaymentMethods.METHOD_UNK) {
        return preferredAppPaymentMethods;
      }
    } else {
      return AppPaymentMethods.METHOD_UNK;
    }

    return AppPaymentMethods.METHOD_UNK;
  }

  AppCurrency getSelectedAppCurrency() {
    if (getSelectedPayment() == AppPaymentMethods.METHOD_VISA) {
      return AppCurrency.DOLLAR;
    } else if (getSelectedPayment() == AppPaymentMethods.METHOD_MASTERCARD) {
      return AppCurrency.DOLLAR;
    } else {
      return AppCurrency.ETB;
    }
  }
}
