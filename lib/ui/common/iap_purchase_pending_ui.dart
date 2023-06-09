import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_consumable_purchase_bloc/iap_consumable_purchase_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:sizer/sizer.dart';

class IapPurchasePendingUi extends StatelessWidget {
  const IapPurchasePendingUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IapConsumablePurchaseBloc, IapConsumablePurchaseState>(
      builder: (context, state) {
        if (state is ShowIapPurchasePendingState) {
          return Container(
            color: ColorMapper.getBlack().withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLoading(
                  size: AppValues.loadingWidgetSize,
                ),
                SizedBox(
                  height: AppMargin.margin_16,
                ),
                Text(
                  AppLocale.of().purchasePending.toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorMapper.getWhite(),
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
