import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_purchase_bloc/iap_subscription_purchase_bloc.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/payment/ethio_tele_subscription_offerings.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class EthioTelecomOfferingCard extends StatelessWidget {
  const EthioTelecomOfferingCard(
      {Key? key, required this.ethioTeleSubscriptionOfferings})
      : super(key: key);

  final EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.padding_16),
      margin: EdgeInsets.all(AppMargin.margin_16),
      decoration: BoxDecoration(
        gradient: AppGradients.getSubscriptionOfferingsGradient(
          ethioTeleSubscriptionOfferings.color1,
          ethioTeleSubscriptionOfferings.color2,
          ethioTeleSubscriptionOfferings.color3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
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
            getTitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
              color: ethioTeleSubscriptionOfferings.textColor,
            ),
          ),

          SizedBox(
            height: AppMargin.margin_6,
          ),

          ///DESCRIPTION
          Text(
            getDescription(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (AppFontSizes.font_size_10 - 1).sp,
              fontWeight: FontWeight.w400,
              color: ethioTeleSubscriptionOfferings.textColor,
            ),
          ),

          SizedBox(
            height: AppMargin.margin_24,
          ),

          ///TRY FOR FREE BUTTON
          buildTryButton(
            context,
            ethioTeleSubscriptionOfferings,
          ),

          SizedBox(
            height: AppMargin.margin_24,
          ),

          ///PRICE DESCRIPTION
          Text(
            getPriceDescription(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
              color: ethioTeleSubscriptionOfferings.textColor,
            ),
          ),

          SizedBox(
            height: AppMargin.margin_8,
          ),

          ///SAVING DESCRIPTION
          ethioTeleSubscriptionOfferings.savingDescriptionEn != null
              ? Text(
                  getSavingDesc(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                    color: ethioTeleSubscriptionOfferings.textColor,
                  ),
                )
              : SizedBox(),

          SizedBox(
            height: AppMargin.margin_16,
          ),

          ///SUB TITLE
          Text(
            getSubTitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w500,
              color: ethioTeleSubscriptionOfferings.textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTryButton(
      context, EthioTeleSubscriptionOfferings ethioTeleSubscriptionOfferings) {
    return AppBouncingButton(
      onTap: () {
        PagesUtilFunctions.ethioTelecomSubscribeClicked(
            ethioTeleSubscriptionOfferings);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_12,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            AppLocale.of().tryForFree.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }

  String getTitle() {
    return L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC ||
            L10nUtil.getCurrentLocale() == AppLanguage.TIGRINYA
        ? ethioTeleSubscriptionOfferings.titleAm
        : ethioTeleSubscriptionOfferings.titleEn;
  }

  String getDescription() {
    return L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC ||
            L10nUtil.getCurrentLocale() == AppLanguage.TIGRINYA
        ? ethioTeleSubscriptionOfferings.descriptionAm
        : ethioTeleSubscriptionOfferings.descriptionEn;
  }

  String getPriceDescription() {
    return L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC ||
            L10nUtil.getCurrentLocale() == AppLanguage.TIGRINYA
        ? ethioTeleSubscriptionOfferings.priceDescriptionAm
        : ethioTeleSubscriptionOfferings.priceDescriptionEn;
  }

  String getSavingDesc() {
    return L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC ||
            L10nUtil.getCurrentLocale() == AppLanguage.TIGRINYA
        ? ethioTeleSubscriptionOfferings.savingDescriptionAm!
        : ethioTeleSubscriptionOfferings.savingDescriptionEn!;
  }

  String getSubTitle() {
    return L10nUtil.getCurrentLocale() == AppLanguage.AMHARIC ||
            L10nUtil.getCurrentLocale() == AppLanguage.TIGRINYA
        ? ethioTeleSubscriptionOfferings.subTitleAm
        : ethioTeleSubscriptionOfferings.subTitleEn;
  }
}

class LocalOfferingCard extends StatelessWidget {
  const LocalOfferingCard({Key? key, required this.subscriptionOfferings})
      : super(key: key);

  final IapSubscriptionOfferings subscriptionOfferings;

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
            color: AppColors.black,
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
            PagesUtilFunctions.getSubscriptionsOfferingPriceDescTxt(
              subscriptionOfferings,
            ),
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
          color: AppColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Center(
          child: Text(
            PagesUtilFunctions.getSubscriptionsOfferingButtonTxt(
              subscriptionOfferings,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
