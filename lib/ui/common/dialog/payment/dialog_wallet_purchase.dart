import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/current_balance_widget.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_filled.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/payment_button_text.dart';
import 'package:mehaley/ui/common/dialog/payment/widgets/purchased_item_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../../app_bouncing_button.dart';
import '../../app_loading.dart';

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
  }) : super(key: key);

  final int itemId;
  final PurchasedItemType purchasedItemType;
  final String itemImageUrl;
  final String itemTitle;
  final String itemSubTitle;
  final double itemPrice;
  final double balance;

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
                buildTopCard(context),

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
                buildItemPurchaseInfo(),

                SizedBox(
                  height: AppMargin.margin_32,
                ),

                ///ACTION BUTTONS
                buildItemPurchaseButtons(context),
                SizedBox(
                  height: AppMargin.margin_8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildItemPurchaseInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_24),
      child: Text(
        "By Purchasing This Mezmur 200.00 Birr Will Be Deducted From Your Wallet",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_8.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.txtGrey,
        ),
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

  Widget buildItemPurchaseButtons(context) {
    return Column(
      children: [
        PaymentButtonFilled(
          title: AppLocale.of().buy,
          onTap: () {},
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
