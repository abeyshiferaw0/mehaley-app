import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/purcahsed_item_status_bloc/purchase_item_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/purchase_item_bloc/purchase_item_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/purchase_item_status_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_wallet_purchase.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/current_balance_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_filled.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_text.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/purchased_item_widget.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_error_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';
import '../../app_loading.dart';

class DialogWalletPurchaseStatus extends StatefulWidget {
  const DialogWalletPurchaseStatus({
    Key? key,
    required this.itemId,
    required this.purchasedItemType,
    required this.itemImageUrl,
    required this.itemTitle,
    required this.itemSubTitle,
  }) : super(key: key);

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final String itemImageUrl;
  final String itemTitle;
  final String itemSubTitle;

  @override
  State<DialogWalletPurchaseStatus> createState() =>
      _DialogWalletPurchaseStatusState();
}

class _DialogWalletPurchaseStatusState
    extends State<DialogWalletPurchaseStatus> {
  @override
  void initState() {
    ///CHEK BALANCE AND ITEM STATUS BEFORE BUYING
    BlocProvider.of<PurchaseItemStatusBloc>(context).add(
      CheckItemPurchaseStatusEvent(
        itemId: widget.itemId,
        purchasedItemType: widget.purchasedItemType,
        itemImageUrl: widget.itemImageUrl,
        itemTitle: widget.itemTitle,
        itemSubTitle: widget.itemSubTitle,
      ),
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
                buildTopCard(context),
                BlocConsumer<PurchaseItemStatusBloc, PurchaseItemStatusState>(
                  listener: (context, state) {
                    ///IF NOT FREE, NOTE ALREADY PURCHASED , NOT BALANCE INSUFFICIENT GO TO PURCHASE DIALOG
                    if (state is PurchaseItemStatusLoadedState) {
                      ///FIRST CHECK IF NOT ALREADY PURCHASED
                      ///THEN CHECK IF IS NOT FREE
                      ///THEN CHECK IF BALANCE IS SUFFICIENT
                      if (!state.purchaseItemStatusData.isAlreadyPurchased &&
                          !state.purchaseItemStatusData.isFree &&
                          state.purchaseItemStatusData.balance >=
                              state.purchaseItemStatusData.priceEtb) {
                        ///GO TO WALLET PURCHASE DIALOG
                        Navigator.pop(context);
                        PagesUtilFunctions.openPurchaseItemDialog(
                          context: context,
                          itemId: widget.itemId,
                          purchasedItemType: widget. purchasedItemType,
                          itemImageUrl: widget. itemImageUrl,
                          itemTitle: widget. itemTitle,
                          itemSubTitle:  widget.itemSubTitle,
                          priceEtb:  state.purchaseItemStatusData.priceEtb,
                          balance:  state.purchaseItemStatusData.balance,
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is PurchaseItemStatusLoadingState) {
                      return buildLoading();
                    }
                    if (state is PurchaseItemStatusLoadingErrorState) {
                      return buildError();
                    }

                    if (state is PurchaseItemStatusLoadedState) {
                      ///FIRST CHECK IF ALREADY PURCHASED
                      if (state.purchaseItemStatusData.isAlreadyPurchased)
                        return buildAlreadyPurchased(
                          context,
                          state.purchaseItemStatusData,
                          state.itemTitle,
                          state.itemSubTitle,
                          state.itemImageUrl,
                          state.purchasedItemType,
                        );

                      ///THEN CHECK IF IS FREE
                      if (state.purchaseItemStatusData.isFree)
                        return buildIsFree(
                          context,
                          state.purchaseItemStatusData,
                          state.itemTitle,
                          state.itemSubTitle,
                          state.itemImageUrl,
                          state.purchasedItemType,
                        );

                      ///THEN CHECK IF BALANCE IS INSUFFICIENT
                      if (state.purchaseItemStatusData.balance <
                          state.purchaseItemStatusData.priceEtb)
                        return buildInsufficientBalance(
                          context,
                          state.purchaseItemStatusData,
                          state.itemTitle,
                          state.itemSubTitle,
                          state.itemImageUrl,
                          state.purchasedItemType,
                        );
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
  Container buildAlreadyPurchased(
    BuildContext context,
    PurchaseItemStatusData purchaseItemStatusData,
    String itemTitle,
    String itemSubTitle,
    String itemImageUrl,
    PurchasedItemType purchasedItemType,
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
          PurchasedItemWidget(
            itemImageUrl: itemImageUrl,
            itemTitle: itemTitle,
            itemSubTitle: itemSubTitle,
            itemPrice: purchaseItemStatusData.priceEtb,
          ),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///TITLE
          buildAlreadyPurchasedTitle(purchasedItemType),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///ACTION BUTTONS
          buildAlreadyPurchasedActionButtons(context),
        ],
      ),
    );
  }

  Container buildIsFree(
    BuildContext context,
    PurchaseItemStatusData purchaseItemStatusData,
    String itemTitle,
    String itemSubTitle,
    String itemImageUrl,
    PurchasedItemType purchasedItemType,
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
          PurchasedItemWidget(
            itemImageUrl: itemImageUrl,
            itemTitle: itemTitle,
            itemSubTitle: itemSubTitle,
            itemPrice: purchaseItemStatusData.priceEtb,
          ),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///TITLE
          buildIsFreeTitle(purchasedItemType),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///ACTION BUTTONS
          buildIsFreeActionButtons(context),

          SizedBox(
            height: AppMargin.margin_8,
          ),
        ],
      ),
    );
  }

  Container buildInsufficientBalance(
    BuildContext context,
    PurchaseItemStatusData purchaseItemStatusData,
    String itemTitle,
    String itemSubTitle,
    String itemImageUrl,
    PurchasedItemType purchasedItemType,
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
          PurchasedItemWidget(
            itemImageUrl: itemImageUrl,
            itemTitle: itemTitle,
            itemSubTitle: itemSubTitle,
            itemPrice: purchaseItemStatusData.priceEtb,
          ),

          SizedBox(
            height: AppMargin.margin_32,
          ),

          ///TITLE
          buildInsufficientBalanceTitle(
            purchaseItemStatusData,
            purchasedItemType,
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
            CheckItemPurchaseStatusEvent(
              itemId: widget.itemId,
              purchasedItemType: widget.purchasedItemType,
              itemImageUrl: widget.itemImageUrl,
              itemTitle: widget.itemTitle,
              itemSubTitle: widget.itemSubTitle,
            ),
          );
        },
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

  Widget buildAlreadyPurchasedTitle(PurchasedItemType purchasedItemType) {
    return Column(
      children: [
        Text(
          AppLocale.of().alreadyPurchased(purchasedItemType: purchasedItemType),
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
          AppLocale.of()
              .alreadyPurchasedMsg(purchasedItemType: purchasedItemType),
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

  Widget buildIsFreeTitle(purchasedItemType) {
    return Column(
      children: [
        Text(
          AppLocale.of().itemIsForFree(purchasedItemType: purchasedItemType),
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
          AppLocale.of().itemIsForFreeMsg(purchasedItemType: purchasedItemType),
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
      PurchaseItemStatusData purchaseItemStatusData,
      PurchasedItemType purchasedItemType) {
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
          balance: purchaseItemStatusData.balance,
        ),
        SizedBox(
          height: AppMargin.margin_16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_16,
          ),
          child: Text(
            AppLocale.of().walletInsufficientMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
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
