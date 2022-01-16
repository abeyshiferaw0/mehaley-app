import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/iap_subscription_purchase_bloc/iap_subscription_purchase_bloc.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:sizer/sizer.dart';

class OfferingCard extends StatelessWidget {
  const OfferingCard({Key? key, required this.subscriptionOfferings})
      : super(key: key);

  final SubscriptionOfferings subscriptionOfferings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_16),
      margin: EdgeInsets.all(AppMargin.margin_16),
      decoration: BoxDecoration(
        gradient: AppGradients.getSubscriptionOfferingsGradient(
          subscriptionOfferings.color1,
          subscriptionOfferings.color2,
          subscriptionOfferings.color3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.placeholderIconColor,
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ///TITLE
          Text(
            subscriptionOfferings.title.toCapitalized(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
              color: subscriptionOfferings.textColor,
            ),
          ),

          SizedBox(
            height: AppMargin.margin_6,
          ),

          ///DESCRIPTION
          Text(
            subscriptionOfferings.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (AppFontSizes.font_size_10 - 1).sp,
              fontWeight: FontWeight.w400,
              color: subscriptionOfferings.textColor,
            ),
          ),

          SizedBox(
            height: AppMargin.margin_24,
          ),

          ///TRY FOR FREE BUTTON
          buildTryButton(
            context,
          ),

          SizedBox(
            height: AppMargin.margin_24,
          ),

          ///PRICE DESCRIPTION
          Text(
            subscriptionOfferings.priceDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
              color: subscriptionOfferings.textColor,
            ),
          ),

          SizedBox(
            height: AppMargin.margin_8,
          ),

          ///SAVING DESCRIPTION
          subscriptionOfferings.savingDescription != null
              ? Text(
                  subscriptionOfferings.savingDescription!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                    color: subscriptionOfferings.textColor,
                  ),
                )
              : SizedBox(),

          SizedBox(
            height: AppMargin.margin_16,
          ),

          ///SUB TITLE
          Text(
            subscriptionOfferings.subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w500,
              color: subscriptionOfferings.textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTryButton(context) {
    return AppBouncingButton(
      onTap: () {
        BlocProvider.of<IapSubscriptionPurchaseBloc>(context).add(
          PurchaseIapSubscriptionOfferingEvent(
            offering: subscriptionOfferings.offering,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_12,
        ),
        decoration: BoxDecoration(
          color: AppColors.completelyBlack.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            "Try for free".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
