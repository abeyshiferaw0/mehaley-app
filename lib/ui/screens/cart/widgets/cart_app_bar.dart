import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/models/cart/cart.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
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
      color: AppColors.pagesBgColor,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    AppLocale.of().cartTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  hasPrice && cart != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocale.of().total,
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(width: AppMargin.margin_4),
                            Icon(
                              Icons.circle,
                              color: AppColors.black,
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
      priceEtb: getTotalPrice(cart, AppCurrency.ETB),
      priceUsd: getTotalPrice(cart, AppCurrency.USD),
      isFree: false,
      useLargerText: true,
      isDiscountAvailable: true,
      discountPercentage: getDeductedPriceAsPercentage(cart),
      isPurchased: false,
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
      priceEtb: getTotalPrice(cart, AppCurrency.ETB),
      priceUsd: getTotalPrice(cart, AppCurrency.USD),
      isFree: false,
      isDiscountAvailable: false,
      discountPercentage: getDeductedPriceAsPercentage(cart),
      useLargerText: true,
      isPurchased: false,
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

  double getTotalPrice(Cart cart, AppCurrency appCurrency) {
    if (appCurrency == AppCurrency.ETB) {
      double total = cart.songCart.totalPriceEtb;
      total = total + cart.albumCart.totalPriceEtb;
      total = total + cart.playlistCart.totalPriceEtb;
      return total;
    } else {
      double total = cart.songCart.totalPriceDollar;
      total = total + cart.albumCart.totalPriceDollar;
      total = total + cart.playlistCart.totalPriceDollar;
      return total;
    }
  }

  // double getDeductedPrice(Cart cart) {
  //   double total = cart.songCart.totalPriceEtb;
  //   total = total + cart.albumCart.totalPriceEtb;
  //   total = total + cart.playlistCart.totalPriceEtb;
  //   return total - cart.deductibleAmountEtb;
  // }

  double getDeductedPriceAsPercentage(Cart cart) {
    if (SettingsDataProvider().getPreferredCurrency() == AppCurrency.ETB) {
      double total = getTotalPrice(cart, AppCurrency.ETB);
      return (cart.deductibleAmountEtb / total);
    } else {
      double total = getTotalPrice(cart, AppCurrency.USD);
      return (cart.deductibleAmountDollar / total);
    }
  }
}
