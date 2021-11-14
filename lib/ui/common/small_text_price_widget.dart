import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/data_providers/settings_data_provider.dart';
import 'package:elf_play/data/models/enums/setting_enums/app_currency.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SmallTextPriceWidget extends StatelessWidget {
  final double priceEtb;
  final double priceUsd;
  final bool isFree;
  final bool useLargerText;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool showDiscount;
  final bool isPurchased;
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
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColors.darkGreen,
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
        color: AppColors.darkGreen,
        fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
        fontSize: useLargerText
            ? AppFontSizes.font_size_12.sp
            : AppFontSizes.font_size_10.sp,
      ),
    );
  }

  Text buildPrice() {
    return Text(
      '${getPrice().toStringAsFixed(2)} ${getPaymentMethod() == AppCurrency.ETB ? 'ETB' : 'USD'}',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColors.darkGreen,
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
            '${getPrice().toStringAsFixed(2)} ${getPaymentMethod() == AppCurrency.ETB ? 'ETB' : 'USD'}',
        style: TextStyle(
          color: AppColors.darkGreen.withOpacity(0.7),
          decoration: TextDecoration.lineThrough,
          fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
          fontSize: useLargerText
              ? AppFontSizes.font_size_10.sp
              : AppFontSizes.font_size_8.sp,
        ),
        children: <InlineSpan>[
          TextSpan(
            text:
                ' ${(getPrice() - (getPrice() * discountPercentage)).toStringAsFixed(2)} ${getPaymentMethod() == AppCurrency.ETB ? 'ETB' : 'USD'}',
            style: TextStyle(
              color: AppColors.darkGreen,
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

  double getPrice() {
    if (getPaymentMethod() == AppCurrency.ETB) {
      return priceEtb;
    } else {
      return priceUsd;
    }
  }
}
