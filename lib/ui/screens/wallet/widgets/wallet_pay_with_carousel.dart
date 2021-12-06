import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/payment_method.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class WalletPayWithCarousel extends StatefulWidget {
  const WalletPayWithCarousel({Key? key, required this.paymentMethods})
      : super(key: key);

  final List<PaymentMethod> paymentMethods;

  @override
  State<WalletPayWithCarousel> createState() => _WalletPayWithCarouselState();
}

class _WalletPayWithCarouselState extends State<WalletPayWithCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pagesBgColor,
      padding: EdgeInsets.symmetric(
        vertical: AppPadding.padding_16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
            ),
            child: Row(
              children: [
                Text(
                  'Powered by',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: AppMargin.margin_4),
                Image.asset(
                  AppAssets.icWeBirr,
                  width: AppIconSizes.icon_size_32,
                  height: AppIconSizes.icon_size_32,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: buildPaymentMethodsRow(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildPaymentMethodsRow() {
    final items = <Widget>[];

    if (widget.paymentMethods.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < widget.paymentMethods.length; i++) {
        items.add(
          buildPaymentMethodInfo(widget.paymentMethods[i]),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_24,
          ),
        );
      }
    }

    return items;
  }

  Widget buildPaymentMethodInfo(PaymentMethod paymentMethod) {
    return AppBouncingButton(
      onTap: () {
        PagesUtilFunctions.goToHowToPayPage(
          context,
          paymentMethod.helpUrl,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppCard(
            radius: 200.0,
            withShadow: false,
            child: Container(
              width: AppIconSizes.icon_size_48,
              height: AppIconSizes.icon_size_48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: AppColors.white,
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl:
                      AppApi.baseUrl + paymentMethod.imageUrl.imageSmallPath,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => buildImagePlaceHolder(),
                  errorWidget: (context, url, error) => buildImagePlaceHolder(),
                ),
              ),
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                L10nUtil.translateLocale(
                        paymentMethod.paymentMethodName, context)
                    .toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_4,
              ),
              Text(
                AppLocale.of().howToPayWith(
                    paymentMethod: L10nUtil.translateLocale(
                        paymentMethod.paymentMethodName, context)),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
  }
}
