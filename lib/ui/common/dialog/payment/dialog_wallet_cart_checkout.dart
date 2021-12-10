import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/purchase_item_bloc/purchase_item_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/checkedout_item_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/current_balance_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_filled.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_text.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';
import '../../app_loading.dart';

class DialogWalletCartCheckOut extends StatefulWidget {
  const DialogWalletCartCheckOut({
    Key? key,
    required this.cartTotalPrice,
    required this.balance,
    required this.onPurchasesSuccess,
  }) : super(key: key);

  final double cartTotalPrice;
  final double balance;
  final VoidCallback onPurchasesSuccess;

  @override
  State<DialogWalletCartCheckOut> createState() =>
      _DialogWalletCartCheckOutState();
}

class _DialogWalletCartCheckOutState extends State<DialogWalletCartCheckOut>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    );
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context);
          widget.onPurchasesSuccess();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                buildTopCard(context),
                BlocConsumer<PurchaseItemBloc, PurchaseItemState>(
                  listener: (context, state) {
                    if (state is CheckOutLoadedState) {
                      // Navigator.pop(context);
                      // widget.onPurchasesSuccess();
                    }
                    if (state is CheckOutLoadingErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        buildAppSnackBar(
                          bgColor: AppColors.errorRed,
                          isFloating: true,
                          msg: AppLocale.of().purchaseNetworkError,
                          txtColor: AppColors.white,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is CheckOutLoadingState) {
                      return buildBuyingLoading();
                    }
                    if (state is CheckOutLoadingErrorState) {
                      return buildBuyingUi(context, true);
                    }
                    if (state is CheckOutLoadedState) {
                      return buildCartCheckedOut(context);
                    }
                    return buildBuyingUi(context, false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildBuyingUi(BuildContext context, bool forError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: AppMargin.margin_32,
        ),

        ///ITEM TO BE PURCHASED
        CheckedOutItemWidget(
          cartTotalPrice: widget.cartTotalPrice,
        ),

        SizedBox(
          height: AppMargin.margin_32,
        ),

        ///CURRENT BALANCE
        CurrentBallanceWidget(
          balance: widget.balance,
        ),

        SizedBox(
          height: AppMargin.margin_16,
        ),

        ///ITEM PURCHASE INFO
        buildItemPurchaseInfo(widget.cartTotalPrice),

        SizedBox(
          height: AppMargin.margin_32,
        ),

        ///ACTION BUTTONS
        buildItemPurchaseButtons(context, forError),
        SizedBox(
          height: AppMargin.margin_8,
        ),
      ],
    );
  }

  Column buildCartCheckedOut(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: AppMargin.margin_32,
        ),
        Lottie.asset(
          AppAssets.cartSuccessLottie,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
          repeat: false,
          width: AppIconSizes.icon_size_72,
          height: AppIconSizes.icon_size_72,
        ),
        SizedBox(
          height: AppMargin.margin_32,
        ),
        Text(
          AppLocale.of().cartCheckedOut.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(
          height: AppMargin.margin_32,
        ),
      ],
    );
  }

  Container buildItemPurchaseInfo(cartTotalPrice) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_24),
      child: Text(
        AppLocale.of().cartCheckOutMsg(
          cartTotalPrice: cartTotalPrice,
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.txtGrey,
        ),
      ),
    );
  }

  Widget buildBuyingLoading() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_32,
          ),
          AppLoading(
            size: AppValues.loadingWidgetSize * 0.8,
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
          Text(
            AppLocale.of().completingPurchase.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
        ],
      ),
    );
  }

  Container buildTopCard(context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_8,
        horizontal: AppPadding.padding_16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.lightGrey,
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              AppAssets.icAppFullIcon,
              width: AppIconSizes.icon_size_48,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AppBouncingButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.padding_4),
                child: Icon(
                  FlutterRemix.close_line,
                  color: AppColors.black,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItemPurchaseButtons(context, bool forError) {
    return Column(
      children: [
        forError
            ? Container(
                margin: EdgeInsets.only(bottom: AppMargin.margin_16),
                child: Text(
                  '${AppLocale.of().couldntConnect.toUpperCase()}\n${AppLocale.of().tryAgain.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.errorRed,
                  ),
                ),
              )
            : SizedBox(),
        PaymentButtonFilled(
          title: AppLocale.of().checkOut,
          onTap: () {
            BlocProvider.of<PurchaseItemBloc>(context).add(
              CheckOutCartEvent(),
            );
          },
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        PaymentButtonText(
          title: AppLocale.of().cancel,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
