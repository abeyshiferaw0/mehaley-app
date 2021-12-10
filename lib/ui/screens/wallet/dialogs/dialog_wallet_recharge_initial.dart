import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_recharge_initial_bloc/wallet_recharge_initial_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_gift_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/copy_button.dart';
import 'package:mehaley/ui/screens/wallet/dialogs/dialog_top_up.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_error_widget.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_pay_with_carousel.dart';
import 'package:mehaley/util/date_util_extention.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogWalletRechargeInitial extends StatefulWidget {
  const DialogWalletRechargeInitial({Key? key}) : super(key: key);

  @override
  State<DialogWalletRechargeInitial> createState() =>
      _DialogWalletRechargeInitialState();
}

class _DialogWalletRechargeInitialState
    extends State<DialogWalletRechargeInitial> {
  @override
  void initState() {
    ///INITIALLY CHECK IF ACTIVE BILL EXISTS
    ///IF EXISTS SHOW PREVIOUS BILL INFO WITH CANCEL BILL OPTIONS
    ///IF NOT GO TO RECHARGE MAIN DIALOG
    BlocProvider.of<WalletRechargeInitialBloc>(context).add(
      CheckShouldWalletRechargeEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletRechargeInitialBloc, WalletRechargeInitialState>(
      listener: (context, state) {
        if (state is WalletRechargeInitialLoadedState) {
          ///UPDATE WALLET PAGE
          BlocProvider.of<WalletPageBloc>(context).add(
            UpdateWalletPageEvent(walletPageData: state.walletPageData),
          );

          ///SHOW FRESH BILL DIALOG
          if (state.showFreshBillDialog) {
            BlocProvider.of<FreshWalletBillCubit>(context)
                .showPaymentConfirmed(state.walletPageData.freshBill!);
          }

          ///SHOW FRESH GIFT NOTIFICATION
          BlocProvider.of<FreshWalletGiftCubit>(context).showGiftReceived(
            state.walletPageData.freshWalletGifts,
          );

          if (state.walletPageData.activeBill == null) {
            goToTopUpDialog(null);
          }
        }
      },
      child: Center(
        child: Wrap(
          children: [
            Material(
              child: Container(
                width: ScreenUtil(context: context).getScreenWidth() * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: BlocBuilder<WalletRechargeInitialBloc,
                    WalletRechargeInitialState>(
                  builder: (context, state) {
                    if (state is WalletRechargeInitialLoadingState) {
                      return buildLoading();
                    }
                    if (state is WalletRechargeInitialLoadingErrorState) {
                      return buildError();
                    }
                    if (state is WalletRechargeInitialLoadedState) {
                      if (state.walletPageData.activeBill != null) {
                        return buildPreviousBillInfo(
                          state.walletPageData.activeBill!,
                          state.walletPageData.paymentMethods,
                        );
                      }
                    }
                    return buildLoading();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreviousBillInfo(
      WebirrBill activeBill, List<PaymentMethod> paymentMethods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDialogHeader(context),
        SizedBox(
          height: AppMargin.margin_24,
        ),
        buildBillInfo(activeBill),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        WalletPayWithCarousel(paymentMethods: paymentMethods),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        buildNewBillButton(
          context,
          activeBill,
        ),
        SizedBox(
          height: AppMargin.margin_24,
        ),
      ],
    );
  }

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
        title: AppLocale.of().walletRechargeInitialErrorMsg,
        subTitle: AppLocale.of().checkYourInternetConnection,
        onRetry: () {
          BlocProvider.of<WalletRechargeInitialBloc>(context).add(
            CheckShouldWalletRechargeEvent(),
          );
        },
      ),
    );
  }

  AppBouncingButton buildNewBillButton(BuildContext context, activeBill) {
    return AppBouncingButton(
      onTap: () {
        goToTopUpDialog(activeBill);
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().cancelBillAndContinue.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            SizedBox(width: AppMargin.margin_8),
            Icon(
              FlutterRemix.arrow_right_s_line,
              color: AppColors.white,
              size: AppIconSizes.icon_size_16,
            ),
          ],
        ),
      ),
    );
  }

  Container buildDialogHeader(context) {
    return Container(
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  AppLocale.of().previousUnPaidBill,
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
            AppLocale.of().unPaidBillMsg,
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

  Container buildBillInfo(WebirrBill activeBill) {
    return Container(
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().amount,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '${activeBill.amount.parsePriceAmount()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontSize: AppFontSizes.font_size_18.sp,
              ),
              children: [
                TextSpan(
                  text: ' ${AppLocale.of().birr}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.txtGrey,
                    fontSize: AppFontSizes.font_size_10.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Text(
            AppLocale.of().unpaidBillCode,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                activeBill.wbcCode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: AppFontSizes.font_size_18.sp,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_8,
              ),
              CopyButton(
                copyText: activeBill.wbcCode,
                title: AppLocale.of().copyCode,
              )
            ],
          ),
        ],
      ),
    );
  }

  void goToTopUpDialog(WebirrBill? activeBill) {
    ///GO TO RECHARGE MAIN DIALOG
    ///ACTIVE IS NULL
    ///POP THIS DIALOG FIRST
    Navigator.pop(context);

    ///GET PROVIDERS BEFORE PASSING BY VALUE
    WalletPageBloc walletPageBloc = BlocProvider.of<WalletPageBloc>(context);
    FreshWalletBillCubit freshWalletBillCubit =
        BlocProvider.of<FreshWalletBillCubit>(context);

    showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: walletPageBloc),
            BlocProvider.value(value: freshWalletBillCubit),
          ],
          child: DialogTopUp(
            activeBill: activeBill,
          ),
        );
      },
    );
  }
}
