import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_recharge_bloc/wallet_recharge_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_gift_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/copy_button.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_error_widget.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_pay_with_carousel.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogWalletRechargeFinal extends StatefulWidget {
  final WebirrBill? activeBill;
  final double selectedAmount;

  const DialogWalletRechargeFinal(
      {Key? key, this.activeBill, required this.selectedAmount})
      : super(key: key);

  @override
  State<DialogWalletRechargeFinal> createState() =>
      _DialogWalletRechargeFinalState();
}

class _DialogWalletRechargeFinalState extends State<DialogWalletRechargeFinal> {
  @override
  void initState() {
    BlocProvider.of<WalletRechargeBloc>(context).add(
      RechargeWalletEvent(
        selectedAmount: widget.selectedAmount,
        shouldCancelPreviousBill: widget.activeBill == null ? false : true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletRechargeBloc, WalletRechargeState>(
      listener: (context, state) {
        if (state is WalletRechargeLoadedState) {
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
                child: BlocBuilder<WalletRechargeBloc, WalletRechargeState>(
                  builder: (context, state) {
                    if (state is WalletRechargeLoadingState) {
                      return buildLoading();
                    }
                    if (state is WalletRechargeLoadingErrorState) {
                      return buildError();
                    }
                    if (state is WalletRechargeLoadedState) {
                      if (state.walletPageData.activeBill == null) {
                        ///THERE MUST BE AN ACTIVE BILL AT THIS POINT
                        return buildError();
                      } else {
                        return buildLoaded(state.walletPageData);
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

  Widget buildLoaded(WalletPageData walletPageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDialogHeader(),
        SizedBox(
          height: AppMargin.margin_24,
        ),
        buildBillInfo(walletPageData.activeBill!),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        WalletPayWithCarousel(
          paymentMethods: walletPageData.paymentMethods,
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        buildButtons(context),
        SizedBox(
          height: AppMargin.margin_16,
        ),
      ],
    );
  }

  Widget buildError() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32),
      child: WidgetErrorWidget(
        title: AppLocale.of().walletRechargeFinalErrorMsg,
        subTitle: AppLocale.of().checkYourInternetConnection,
        onRetry: () {
          BlocProvider.of<WalletRechargeBloc>(context).add(
            RechargeWalletEvent(
              selectedAmount: widget.selectedAmount,
              shouldCancelPreviousBill:
                  widget.activeBill == null ? false : true,
            ),
          );
        },
      ),
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

  Column buildButtons(BuildContext context) {
    return Column(
      children: [
        AppBouncingButton(
          onTap: () {
            PagesUtilFunctions.goToHowToPayPage(
              context,
              AppValues.howToPayHelpGeneralUrl,
            );
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
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocale.of().howToPay.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        AppBouncingButton(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocale.of().done.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container buildDialogHeader() {
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
                  AppLocale.of().payBill,
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
            AppLocale.of().payBillMsg,
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
              text: '${activeBill.amount}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontSize: AppFontSizes.font_size_18.sp,
              ),
              children: [
                TextSpan(
                  text: ' ${AppLocale.of().birr}',
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
            height: AppMargin.margin_16,
          ),
          Text(
            AppLocale.of().billCode,
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
                MaskedTextController(
                  text: activeBill.wbcCode,
                  mask: '000 000 000',
                ).text,
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
                copyText: '${activeBill.wbcCode}',
                title: AppLocale.of().copyCode,
              )
            ],
          ),
        ],
      ),
    );
  }
}
