import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/purcahsed_item_status_bloc/purchase_item_status_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_gift_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/cart_check_out_status_data.dart';
import 'package:mehaley/ui/common/app_top_header_with_icon.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/checkedout_item_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/current_balance_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_filled.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_text.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_error_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_loading.dart';

class DialogCartCheckOutStatus extends StatefulWidget {
  const DialogCartCheckOutStatus({
    Key? key,
    required this.onPurchasesSuccess,
  }) : super(key: key);

  final VoidCallback onPurchasesSuccess;

  @override
  State<DialogCartCheckOutStatus> createState() =>
      _DialogCartCheckOutStatusState();
}

class _DialogCartCheckOutStatusState extends State<DialogCartCheckOutStatus> {
  @override
  void initState() {
    ///CHEK BALANCE AND ITEM STATUS BEFORE CHECKING OUT
    BlocProvider.of<PurchaseItemStatusBloc>(context).add(
      CheckCartCheckOutStatusEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            width: ScreenUtil(context: context).getScreenWidth() * 0.8,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///TOP HEADER
                AppTopHeaderWithIcon(),
                BlocConsumer<PurchaseItemStatusBloc, PurchaseItemStatusState>(
                  listener: (context, state) {
                    ///IF NOTE ALREADY CHECKED OUT(TOTAL PRICE = 0.0) , NOT BALANCE INSUFFICIENT GO TO CHECKOUT DIALOG
                    if (state is CartCheckoutStatusLoadedState) {
                      ///FIRST CHECK IF NOT ALREADY CHECKED OUT
                      ///THEN CHECK IF BALANCE IS SUFFICIENT
                      if ((state.cartCheckOutStatusData.cartTotalEtb > 0.0) &&
                          (state.cartCheckOutStatusData.balance >=
                              state.cartCheckOutStatusData.cartTotalEtb)) {
                        ///GO TO CHECK OUT DIALOG DIALOG
                        Navigator.pop(context);
                        PagesUtilFunctions.openCartCheckOutDialog(
                          context: context,
                          cartTotalPrice:
                              state.cartCheckOutStatusData.cartTotalEtb,
                          balance: state.cartCheckOutStatusData.balance,
                          onPurchasesSuccess: widget.onPurchasesSuccess,
                        );
                      }

                      ///SHOW FRESH GIFT NOTIFICATION
                      BlocProvider.of<FreshWalletGiftCubit>(context)
                          .showGiftReceived(
                        state.cartCheckOutStatusData.freshWalletGifts,
                      );

                      ///SHOW FRESH BILL DIALOG
                      if (state.cartCheckOutStatusData.freshBill != null) {
                        BlocProvider.of<FreshWalletBillCubit>(context)
                            .showPaymentConfirmed(
                          state.cartCheckOutStatusData.freshBill!,
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is CartCheckoutStatusLoadingState) {
                      return buildLoading();
                    }
                    if (state is CartCheckoutStatusLoadingErrorState) {
                      return buildError();
                    }

                    if (state is CartCheckoutStatusLoadedState) {
                      ///FIRST CHECK IF ALREADY PURCHASED
                      if (state.cartCheckOutStatusData.cartTotalEtb <= 0.0)
                        return buildAlreadyCheckedOut(
                          context,
                          state.cartCheckOutStatusData,
                        );

                      ///THEN CHECK IF BALANCE IS INSUFFICIENT
                      if (state.cartCheckOutStatusData.balance <
                          state.cartCheckOutStatusData.cartTotalEtb) {
                        return buildInsufficientBalance(
                          context,
                          state.cartCheckOutStatusData,
                        );
                      }
                    }
                    return buildLoading();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///MAIN WIDGET BUILDERS
  Container buildAlreadyCheckedOut(
    BuildContext context,
    CartCheckOutStatusData cartCheckOutStatusData,
  ) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_16,
          ),

          ///PURCHASED ITEM WIDGET
          CheckedOutItemWidget(
            cartTotalPrice: cartCheckOutStatusData.cartTotalEtb,
          ),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///TITLE
          buildAlreadyCheckedOutTitle(),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///ACTION BUTTONS
          buildAlreadyPurchasedActionButtons(context),
        ],
      ),
    );
  }

  Container buildInsufficientBalance(
    BuildContext context,
    CartCheckOutStatusData cartCheckOutStatusData,
  ) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_16,
          ),

          ///PURCHASED ITEM WIDGET
          CheckedOutItemWidget(
            cartTotalPrice: cartCheckOutStatusData.cartTotalEtb,
          ),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///TITLE
          buildInsufficientBalanceTitle(
            cartCheckOutStatusData,
          ),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///ACTION BUTTONS
          buildInsufficientBalanceButtons(context),
        ],
      ),
    );
  }

  ///MAIN WIDGET BUILDERS

  Widget buildLoading() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      child: AppLoading(
        size: AppValues.loadingWidgetSize * 0.8,
      ),
    );
  }

  Widget buildError() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      child: WidgetErrorWidget(
        title: AppLocale.of().noInternetMsg,
        subTitle: AppLocale.of().checkYourInternetConnection,
        onRetry: () {
          ///CHEK BALANCE AND ITEM STATUS BEFORE BUYING
          BlocProvider.of<PurchaseItemStatusBloc>(context).add(
            CheckCartCheckOutStatusEvent(),
          );
        },
      ),
    );
  }

  Widget buildAlreadyCheckedOutTitle() {
    return Column(
      children: [
        Text(
          AppLocale.of().cartAlreadyCheckedOut,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Text(
          AppLocale.of().cartAlreadyCheckedOutMsg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.txtGrey,
          ),
        )
      ],
    );
  }

  Widget buildInsufficientBalanceTitle(
      CartCheckOutStatusData cartCheckOutStatusData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocale.of().walletInsufficient,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        CurrentBallanceWidget(
          balance: cartCheckOutStatusData.balance,
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_4,
          ),
          child: Text(
            AppLocale.of().walletInsufficientMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
        )
      ],
    );
  }

  Widget buildAlreadyPurchasedActionButtons(context) {
    return Column(
      children: [
        PaymentButtonFilled(
          title: AppLocale.of().close,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
      ],
    );
  }

  Widget buildIsFreeActionButtons(context) {
    return Column(
      children: [
        PaymentButtonFilled(
          title: AppLocale.of().close,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget buildInsufficientBalanceButtons(context) {
    return Column(
      children: [
        PaymentButtonFilled(
          title: AppLocale.of().rechargeWallet,
          onTap: () {
            Navigator.pop(context);
            PagesUtilFunctions.goToWalletPage(
              context,
              startRechargeProcess: true,
            );
          },
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        PaymentButtonText(
          title: AppLocale.of().close,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
