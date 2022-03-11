import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:mehaley/data/models/payment/iap_product.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:sizer/sizer.dart';

class SmallTextPriceWidget extends StatelessWidget {
  final double priceEtb;
  final IapProduct priceUsd;
  final bool isFree;
  final bool useLargerText;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool showDiscount;
  final bool isPurchased;
  final bool? useDimColor;
  final AppCurrency? appCurrency;

  const SmallTextPriceWidget({
    Key? key,
    required this.priceEtb,
    required this.priceUsd,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    this.useLargerText = false,
    this.showDiscount = true,
    required this.isPurchased,
    this.appCurrency,
    this.useDimColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPurchased) {
      return buildPurchased(context);
    } else {
      if (!isFree) {
        if (isDiscountAvailable && showDiscount) {
          return buildDiscountAvailablePrice();
        } else {
          return buildPrice();
        }
      } else {
        return buildFreeText(context);
      }
    }
  }

  Text buildPurchased(context) {
    return Text(
      AppLocale.of().purchased.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: ColorMapper.getDarkOrange(),
        fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
        fontSize: useLargerText
            ? AppFontSizes.font_size_12.sp
            : AppFontSizes.font_size_10.sp,
      ),
    );
  }

  Text buildFreeText(context) {
    return Text(
      AppLocale.of().free.toUpperCase(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: shouldUseDimmedColor()
            ? ColorMapper.getOrange()
            : ColorMapper.getDarkOrange(),
        fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
        fontSize: useLargerText
            ? AppFontSizes.font_size_12.sp
            : AppFontSizes.font_size_10.sp,
      ),
    );
  }

  Text buildPrice() {
    return Text(
      '${getPrice().parsePriceAmount()} ${getPaymentMethod() == AppCurrency.ETB ? 'ETB' : 'USD'}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: shouldUseDimmedColor()
            ? ColorMapper.getOrange()
            : ColorMapper.getDarkOrange(),
        fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
        fontSize: useLargerText
            ? AppFontSizes.font_size_12.sp
            : AppFontSizes.font_size_10.sp,
      ),
    );
  }

  Text buildDiscountAvailablePrice() {
    return Text.rich(
      TextSpan(
        text:
            '${getPrice().parsePriceAmount()} ${getPaymentMethod() == AppCurrency.ETB ? 'ETB' : 'USD'}',
        style: TextStyle(
          color: shouldUseDimmedColor()
              ? ColorMapper.getOrange().withOpacity(0.7)
              : ColorMapper.getDarkOrange().withOpacity(0.7),
          decoration: TextDecoration.lineThrough,
          fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
          fontSize: useLargerText
              ? AppFontSizes.font_size_10.sp
              : AppFontSizes.font_size_8.sp,
        ),
        children: <InlineSpan>[
          TextSpan(
            text:
                ' ${(getPrice() - (getPrice() * discountPercentage)).parsePriceAmount()} ${getPaymentMethod() == AppCurrency.ETB ? 'ETB' : 'USD'}',
            style: TextStyle(
              color: shouldUseDimmedColor()
                  ? ColorMapper.getOrange()
                  : ColorMapper.getDarkOrange(),
              decoration: TextDecoration.none,
              fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
              fontSize: useLargerText
                  ? AppFontSizes.font_size_12.sp
                  : AppFontSizes.font_size_10.sp,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  AppCurrency getPaymentMethod() {
    if (appCurrency == null) {
      return SettingsDataProvider().getPreferredCurrency();
    } else {
      return appCurrency!;
    }
  }

  bool shouldUseDimmedColor() {
    if (useDimColor == null) {
      return false;
    }
    if (useDimColor!) {
      return true;
    }
    return false;
  }

  double getPrice() {
    if (getPaymentMethod() == AppCurrency.ETB) {
      return priceEtb;
    } else {
      return priceUsd.productPrice;
    }
  }
}
