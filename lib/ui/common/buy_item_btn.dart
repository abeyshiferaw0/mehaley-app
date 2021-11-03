import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/small_text_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BuyItemBtnWidget extends StatelessWidget {
  final double price;
  final String title;
  final bool hasLeftMargin;
  final bool isFree;
  final bool showDiscount;
  final bool isDiscountAvailable;
  final double discountPercentage;
  final bool isCentred;
  final bool isBought;

  const BuyItemBtnWidget({
    Key? key,
    required this.price,
    required this.title,
    required this.hasLeftMargin,
    required this.isDiscountAvailable,
    required this.discountPercentage,
    required this.isFree,
    this.isCentred = false,
    this.showDiscount = true,
    required this.isBought,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isBought) {
      return SmallTextPriceWidget(
        price: price,
        isFree: isFree,
        useLargerText: true,
        showDiscount: showDiscount,
        isDiscountAvailable: isDiscountAvailable,
        discountPercentage: discountPercentage,
        isPurchased: isBought,
      );
    } else {
      return AppBouncingButton(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_20,
            vertical: AppPadding.padding_8,
          ),
          margin:
              EdgeInsets.only(left: hasLeftMargin ? AppMargin.margin_16 : 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: AppColors.lightGrey,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                isCentred ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              SizedBox(width: AppMargin.margin_4),
              SmallTextPriceWidget(
                price: price,
                isFree: isFree,
                useLargerText: true,
                showDiscount: showDiscount,
                isDiscountAvailable: isDiscountAvailable,
                discountPercentage: discountPercentage,
                isPurchased: isBought,
              )
            ],
          ),
        ),
      );
    }
  }
}
