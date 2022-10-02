import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/ethio_telecom_subscription_util.dart';
import 'package:sizer/sizer.dart';

import 'app_gradients.dart';

class AppSubscriptionActiveCard extends StatefulWidget {
  const AppSubscriptionActiveCard({
    Key? key,
    required this.topMargin,
    required this.bottomMargin,
  }) : super(key: key);

  final double topMargin;
  final double bottomMargin;

  @override
  State<AppSubscriptionActiveCard> createState() =>
      _AppSubscriptionActiveCardState();
}

class _AppSubscriptionActiveCardState extends State<AppSubscriptionActiveCard> {
  final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();

  @override
  Widget build(BuildContext context) {
    if (!isUserSubscribed) {
      return SizedBox();
    } else {
      return Column(
        children: [
          SizedBox(
            height: widget.topMargin,
          ),
          Stack(
            children: [
              ///BG GRADIENT
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppGradients.getOfflineLibraryGradient(),
                  ),
                ),
              ),

              Positioned.fill(
                child: Image.asset(
                  AppAssets.imageSubscribeCardBg,
                  fit: BoxFit.cover,
                ),
              ),

              ///BG TRANSPARENT
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  color: ColorMapper.getCompletelyBlack().withOpacity(
                    0.2,
                  ),
                ),
              ),

              ///FRONT ITEMS
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.padding_16,
                  horizontal: AppPadding.padding_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocale.of().subscribed.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        color: ColorMapper.getWhite(),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_8,
                    ),
                    Text(
                      PagesUtilFunctions.isUserLocalSubscribed()
                          ? ''
                          : AppLocale.of().youHavPremiumAccountMsg(
                              isAndroid: Platform.isAndroid),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: ColorMapper.getWhite(),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: widget.bottomMargin,
          ),
        ],
      );
    }
  }
}
