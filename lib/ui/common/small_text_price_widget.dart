import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SmallTextPriceWidget extends StatelessWidget {
  final double price;
  final bool isFree;
  final bool useLargerText;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool showDiscount;
  final bool isPurchased;

  const SmallTextPriceWidget({
    Key? key,
    required this.price,
    required this.isFree,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    this.useLargerText = false,
    this.showDiscount = true,
    required this.isPurchased,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isPurchased){
      return buildPurchased();
    }else{
      if (!isFree) {
        if (isDiscountAvailable && showDiscount) {
          return buildDiscountAvailablePrice();
        } else {
          return buildPrice();
        }
      } else {
        return buildFreeText();
      }
    }

  }

  Text buildPurchased() {
    return Text(
      "PURCHASED",
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

  Text buildFreeText() {
    return Text(
      "FREE",
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
      "\$${price.toStringAsFixed(2)}",
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

  Row buildDiscountAvailablePrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "\$${price.toStringAsFixed(2)}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.darkGreen.withOpacity(0.7),
            decoration: TextDecoration.lineThrough,
            fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
            fontSize: useLargerText
                ? AppFontSizes.font_size_10.sp
                : AppFontSizes.font_size_8.sp,
          ),
        ),
        SizedBox(width: AppMargin.margin_4),
        Text(
          "\$${(price - (price * discountPercentage)).toStringAsFixed(2)}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: useLargerText ? FontWeight.bold : FontWeight.w600,
            fontSize: useLargerText
                ? AppFontSizes.font_size_12.sp
                : AppFontSizes.font_size_10.sp,
          ),
        )
      ],
    );
  }
}
