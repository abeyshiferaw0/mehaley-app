import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/cart/cart.dart';
import 'package:elf_play/ui/common/small_text_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class CartAppBar extends StatelessWidget {
  const CartAppBar({
    Key? key,
    required this.hasPrice,
    this.cart,
    required this.height,
  }) : super(key: key);

  final bool hasPrice;
  final double height;
  final Cart? cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
                    AppLocalizations.of(context)!.cartTitle,
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
                              AppLocalizations.of(context)!.total,
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
                            isDiscountAve(cart!)
                                ? buildDeductedPrice(cart!)
                                : buildTotalPrice(cart!),
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

  Widget buildDeductedPrice(Cart cart) {
    return SmallTextPriceWidget(
      price: getTotalPrice(cart),
      isFree: false,
      isDiscountAvailable: true,
      discountPercentage: getDeductedPriceAsPercentage(cart),
      isPurchased: false,
      appCurrency: AppCurrency.ETB,
    );
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Text(
    //       '\$${getTotalPrice(cart).toStringAsFixed(2)}',
    //       maxLines: 2,
    //       overflow: TextOverflow.ellipsis,
    //       style: TextStyle(
    //         color: AppColors.darkGreen.withOpacity(0.7),
    //         decoration: TextDecoration.lineThrough,
    //         fontSize: AppFontSizes.font_size_12.sp,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //     SizedBox(width: AppMargin.margin_4),
    //     Text(
    //       '\$${getDeductedPrice(cart).toStringAsFixed(2)}',
    //       maxLines: 2,
    //       overflow: TextOverflow.ellipsis,
    //       style: TextStyle(
    //         fontSize: AppFontSizes.font_size_14.sp,
    //         fontWeight: FontWeight.w700,
    //         color: AppColors.darkGreen,
    //       ),
    //     )
    //   ],
    // );
  }

  Widget buildTotalPrice(Cart cart) {
    return SmallTextPriceWidget(
      price: getTotalPrice(cart),
      isFree: false,
      isDiscountAvailable: false,
      discountPercentage: getDeductedPrice(cart),
      useLargerText: true,
      isPurchased: false,
      appCurrency: AppCurrency.ETB,
    );
    // return Text(
    //   '\$${getDeductedPrice(cart).toStringAsFixed(2)}',
    //   maxLines: 2,
    //   overflow: TextOverflow.ellipsis,
    //   style: TextStyle(
    //     fontSize: AppFontSizes.font_size_14.sp,
    //     fontWeight: FontWeight.w700,
    //     color: AppColors.darkGreen,
    //   ),
    // );
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

  double getDeductedPriceAsPercentage(Cart cart) {
    double total = cart.songCart.totalPriceEtb;
    total = total + cart.albumCart.totalPriceEtb;
    total = total + cart.playlistCart.totalPriceEtb;
    return (cart.deductibleAmountEtb * 100) / total;
  }
}
