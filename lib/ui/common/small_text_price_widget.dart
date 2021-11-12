import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class SmallTextPriceWidget extends StatelessWidget {
  final double price;
  final bool isFree;
  final bool useLargerText;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool showDiscount;
  final bool isPurchased;
  final AppCurrency appCurrency;

  const SmallTextPriceWidget({
    Key? key,
    required this.price,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    this.useLargerText = false,
    this.showDiscount = true,
    required this.isPurchased,
    required this.appCurrency,
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
      AppLocalizations.of(context)!.purchased.toUpperCase(),
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
      AppLocalizations.of(context)!.free.toUpperCase(),
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
      '${price.toStringAsFixed(2)} ${appCurrency == AppCurrency.ETB ? 'ETB' : 'USD'}',
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
            '${price.toStringAsFixed(2)} ${appCurrency == AppCurrency.ETB ? 'ETB' : 'USD'}',
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
                ' ${(price - (price * discountPercentage)).toStringAsFixed(2)} ${appCurrency == AppCurrency.ETB ? 'ETB' : 'USD'}',
            style: TextStyle(
              color: AppColors.darkGreen,
              decoration: TextDecoration.none,
              fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
              fontSize: useLargerText
                  ? AppFontSizes.font_size_12.sp
                  : AppFontSizes.font_size_10.sp,
            ),
          )
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
