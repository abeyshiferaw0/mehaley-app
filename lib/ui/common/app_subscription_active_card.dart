import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
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
                  color: AppColors.completelyBlack.withOpacity(
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
                      "Subscribed".toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_8,
                    ),
                    Text(
                      "You have a premium account\nmanage your subscriptions with ${Platform.isAndroid ? "google play store" : "App Store"}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.white,
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
