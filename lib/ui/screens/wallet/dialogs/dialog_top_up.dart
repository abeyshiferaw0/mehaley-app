import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_recharge_bloc/wallet_recharge_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/wallet/dialogs/dialog_wallet_recharge_final.dart';
import 'package:mehaley/util/date_util_extention.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogTopUp extends StatefulWidget {
  final WebirrBill? activeBill;

  const DialogTopUp({Key? key, required this.activeBill}) : super(key: key);

  @override
  State<DialogTopUp> createState() => _DialogTopUpState();
}

class _DialogTopUpState extends State<DialogTopUp> {
  late FocusNode focusNode;
  late TextEditingController controller;

  ///VALIDATION AND VALUE
  double selectedAmount = 5.0;
  bool isScrollSelectorSet = true;
  bool hasError = false;

  @override
  void initState() {
    focusNode = FocusNode();
    controller = TextEditingController();
    super.initState();
  }

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
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.padding_16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildDialogHeader(),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Divider(
                    color: AppColors.lightGrey,
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  buildSelectedAmount(),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  Divider(
                    color: AppColors.lightGrey,
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  buildFixedAmounts(),
                  SizedBox(
                    height: AppMargin.margin_48,
                  ),
                  buildOrContainer(),
                  SizedBox(
                    height: AppMargin.margin_48,
                  ),
                  buildTextFormField(),
                  SizedBox(
                    height: AppMargin.margin_24,
                  ),
                  buildPayButton(),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBouncingButton buildPayButton() {
    return AppBouncingButton(
      disableBouncing: hasError,
      onTap: () {
        if (isSelectedAmountValid()) {
          ///POP THIS DIALOG FIRST
          ///THEN GO TO RECHARGING DIALOG
          Navigator.pop(context);

          ///GET PROVIDERS BEFORE PASSING BY VALUE
          WalletPageBloc walletPageBloc =
              BlocProvider.of<WalletPageBloc>(context);
          FreshWalletBillCubit freshWalletBillCubit =
              BlocProvider.of<FreshWalletBillCubit>(context);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => WalletRechargeBloc(
                      walletDataRepository:
                          AppRepositories.walletDataRepository,
                    ),
                  ),
                  BlocProvider.value(value: walletPageBloc),
                  BlocProvider.value(value: freshWalletBillCubit),
                ],
                child: DialogWalletRechargeFinal(
                  activeBill: widget.activeBill,
                  selectedAmount: selectedAmount,
                ),
              );
            },
          );
        } else {
          ///SHOW INVALID AMOUNT MESSAGE
          ScaffoldMessenger.of(context).showSnackBar(
            buildAppSnackBar(
              bgColor: AppColors.black.withOpacity(0.9),
              isFloating: true,
              msg: AppLocale.of().invalidWalletRechargeAmountSelected,
              txtColor: AppColors.white,
            ),
          );
        }
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
          color: hasError ? AppColors.grey : AppColors.darkOrange,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().proceedToPayment.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            SizedBox(width: AppMargin.margin_12),
            Icon(
              FlutterRemix.arrow_right_s_line,
              size: AppIconSizes.icon_size_20,
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Container buildTextFormField() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Column(
        children: [
          Text(
            AppLocale.of().enterOtherAmount.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            //autofocus: true,
            focusNode: focusNode,
            controller: controller,
            cursorColor: AppColors.darkOrange,
            onChanged: (key) {
              if (key.isEmpty) {
                setTextAmountError();
              } else {
                try {
                  double d = double.parse(key);
                  if (d < 1.0) {
                    setTextAmountError();
                  } else {
                    setTextAmountSelected(d);
                  }
                } catch (e) {
                  setTextAmountError();
                }
              }
            },
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            validator: (text) {
              if (text == null || text.isEmpty) {
                return setTextAmountError();
              } else {
                try {
                  double d = double.parse(text);
                  return d < 1.0 ? setTextAmountError() : null;
                } catch (e) {
                  return setTextAmountError();
                }
              }
            },
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w600,
            ),
            buildCounter: (
              context, {
              required currentLength,
              maxLength,
              required isFocused,
            }) =>
                Text(
              '$currentLength/$maxLength',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.darkOrange,
                fontSize: AppFontSizes.font_size_10,
              ),
            ),
            maxLength: 12,
            decoration: InputDecoration(
              fillColor: AppColors.black,
              focusColor: AppColors.black,
              hoverColor: AppColors.black,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                fontSize: AppFontSizes.font_size_10,
                color: AppColors.errorRed,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.txtGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.darkOrange),
              ),
              disabledBorder: InputBorder.none,
              hintText: '00.00 ${AppLocale.of().birr.toUpperCase()}',
              hintStyle: TextStyle(
                color: AppColors.txtGrey,
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildOrContainer() {
    return Container(
      width: AppIconSizes.icon_size_48,
      height: AppIconSizes.icon_size_48,
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(150.0),
      ),
      padding: EdgeInsets.all(
        AppPadding.padding_4,
      ),
      child: Center(
        child: Text(
          AppLocale.of().or.toUpperCase(),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_8.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  Container buildDialogHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  AppLocale.of().rechargeYourWallet,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              AppBouncingButton(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    FlutterRemix.close_line,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Text(
            AppLocale.of().billInfoMsg,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
        ],
      ),
    );
  }

  Column buildFixedAmounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(
            AppPadding.padding_16,
          ),
          child: Text(
            AppLocale.of().selectAmountToTopUp.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: AppMargin.margin_16,
              ),
              buildFixedAmountItem(
                amount: 5.0,
                isSelected: isScrollSelectorSelected(5.0),
                onTap: (amount) {
                  setScrollSelectorSelected(amount);
                },
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
              buildFixedAmountItem(
                amount: 10.0,
                isSelected: isScrollSelectorSelected(10.0),
                onTap: (amount) {
                  setScrollSelectorSelected(amount);
                },
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
              buildFixedAmountItem(
                amount: 25.0,
                isSelected: isScrollSelectorSelected(25.0),
                onTap: (amount) {
                  setScrollSelectorSelected(amount);
                },
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
              buildFixedAmountItem(
                amount: 50.0,
                isSelected: isScrollSelectorSelected(50.0),
                onTap: (amount) {
                  setScrollSelectorSelected(amount);
                },
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
              buildFixedAmountItem(
                amount: 100.0,
                isSelected: isScrollSelectorSelected(100.0),
                onTap: (amount) {
                  setScrollSelectorSelected(amount);
                },
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBouncingButton buildFixedAmountItem(
      {required double amount,
      required bool isSelected,
      required Function(double amount) onTap}) {
    return AppBouncingButton(
      onTap: () {
        onTap(amount);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_8,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: isSelected ? AppColors.orange : AppColors.txtGrey,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.completelyBlack.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '$amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: AppFontSizes.font_size_18.sp,
                ),
                children: [
                  TextSpan(
                    text: ' ${AppLocale.of().birr}'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.txtGrey,
                      fontSize: AppFontSizes.font_size_10.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: AppMargin.margin_16,
            ),
            isSelected
                ? Icon(
                    FlutterRemix.checkbox_circle_fill,
                    color: AppColors.orange,
                    size: AppIconSizes.icon_size_24,
                  )
                : SizedBox(
                    width: AppIconSizes.icon_size_24,
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of().selectedAmount.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.txtGrey,
            fontSize: AppFontSizes.font_size_8.sp,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '${selectedAmount.parsePriceAmount()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: hasError ? AppColors.errorRed : AppColors.darkOrange,
              fontSize: AppFontSizes.font_size_18.sp,
            ),
            children: [
              TextSpan(
                text: ' ${AppLocale.of().birr.toUpperCase()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.txtGrey,
                  fontSize: AppFontSizes.font_size_10.sp,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: hasError,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.padding_8),
            child: Text(
              AppLocale.of().invalidWalletRechargeAmountSelected,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.errorRed,
                fontSize: AppFontSizes.font_size_8.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isScrollSelectorSelected(double amount) {
    if (!isScrollSelectorSet) return false;
    if (amount == selectedAmount) return true;
    return false;
  }

  void setScrollSelectorSelected(double amount) {
    setState(() {
      isScrollSelectorSet = true;
      selectedAmount = amount;
      hasError = false;
      controller.clear();
      focusNode.unfocus();
    });
  }

  String setTextAmountError() {
    setState(() {
      isScrollSelectorSet = false;
      selectedAmount = 0.0;
      hasError = true;
    });
    return AppLocale.of().invalidWalletRechargeAmountSelected;
  }

  setTextAmountSelected(double amount) {
    setState(() {
      isScrollSelectorSet = false;
      selectedAmount = amount;
      hasError = false;
    });
    return AppLocale.of().invalidWalletRechargeAmountSelected;
  }

  bool isSelectedAmountValid() {
    if (selectedAmount < 1.0) {
      setTextAmountError();
      return false;
    } else {
      return true;
    }
  }
}
