import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({
    Key? key,
    required this.hasPrice,
    this.cart,
  }) : super(key: key);

  final bool hasPrice;
  final Cart? cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: AppColors.black,
      child: SafeArea(
        child: Container(
          color: AppColors.darkGrey,
          padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                  AppLocalizations.of(context)!.cartTitle  ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  hasPrice && cart != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.total  ,
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(width: AppMargin.margin_4),
                            Icon(
                              Icons.circle,
                              color: AppColors.white,
                              size: AppIconSizes.icon_size_4,
                            ),
                            SizedBox(width: AppMargin.margin_4),
                            isDiscountAve(cart!) ? buildDeductedPrice(cart!) : buildTotalPrice(cart!),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildDeductedPrice(Cart cart) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "\$${getTotalPrice(cart).toStringAsFixed(2)}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.darkGreen.withOpacity(0.7),
            decoration: TextDecoration.lineThrough,
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: AppMargin.margin_4),
        Text(
          "\$${getDeductedPrice(cart).toStringAsFixed(2)}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGreen,
          ),
        )
      ],
    );
  }

  Text buildTotalPrice(Cart cart) {
    return Text(
      "\$${getDeductedPrice(cart).toStringAsFixed(2)}",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_14.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGreen,
      ),
    );
  }

  bool isDiscountAve(Cart cart) {
    return cart.deductibleAmountEtb > 0 ? true : false;
  }

  double getTotalPrice(Cart cart) {
    double total = cart.songCart.totalPriceEtb;
    total = total + cart.albumCart.totalPriceEtb;
    total = total + cart.playlistCart.totalPriceEtb;
    return total;
  }

  double getDeductedPrice(Cart cart) {
    double total = cart.songCart.totalPriceEtb;
    total = total + cart.albumCart.totalPriceEtb;
    total = total + cart.playlistCart.totalPriceEtb;
    return total - cart.deductibleAmountEtb;
  }
}
