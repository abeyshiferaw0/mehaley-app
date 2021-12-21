import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/purchase_item_bloc/purchase_item_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/current_balance_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_filled.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_text.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/purchased_item_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_loading.dart';
import '../../app_top_header_with_icon.dart';

class DialogWalletPurchase extends StatefulWidget {
  const DialogWalletPurchase({
    Key? key,
    required this.itemId,
    required this.purchasedItemType,
    required this.itemImageUrl,
    required this.itemTitle,
    required this.itemSubTitle,
    required this.itemPrice,
    required this.balance,
    required this.onPurchasesSuccess,
  }) : super(key: key);

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final String itemImageUrl;
  final String itemTitle;
  final String itemSubTitle;
  final double itemPrice;
  final double balance;
  final VoidCallback onPurchasesSuccess;

  @override
  State<DialogWalletPurchase> createState() => _DialogWalletPurchaseState();
}

class _DialogWalletPurchaseState extends State<DialogWalletPurchase> {
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
                BlocConsumer<PurchaseItemBloc, PurchaseItemState>(
                  listener: (context, state) {
                    if (state is PurchaseItemLoadedState) {
                      Navigator.pop(context);
                      widget.onPurchasesSuccess();
                    }
                    if (state is PurchaseItemLoadingErrorState) {
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
                    if (state is PurchaseItemLoadingState) {
                      return buildBuyingLoading();
                    }
                    if (state is PurchaseItemLoadingErrorState) {
                      return buildBuyingUi(context, true);
                    }
                    if (state is PurchaseItemLoadedState) {
                      return buildBuyingLoading();
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
        PurchasedItemWidget(
          itemPrice: widget.itemPrice,
          itemImageUrl: widget.itemImageUrl,
          itemTitle: widget.itemTitle,
          itemSubTitle: widget.itemSubTitle,
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
        buildItemPurchaseInfo(widget.itemPrice, widget.purchasedItemType),

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

  Container buildItemPurchaseInfo(amount, purchasedItemType) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_24),
      child: Text(
        AppLocale.of().purchaseItemMsg(
          amount: amount,
          purchasedItemType: purchasedItemType,
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
          title: AppLocale.of().buy,
          onTap: () {
            BlocProvider.of<PurchaseItemBloc>(context).add(
              PurchaseItem(
                itemId: widget.itemId,
                purchasedItemType: widget.purchasedItemType,
              ),
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
