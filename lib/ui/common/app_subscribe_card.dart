import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

import 'app_bouncing_button.dart';
import 'app_gradients.dart';

class AppSubscribeCard extends StatefulWidget {
  const AppSubscribeCard({
    Key? key,
    required this.topMargin,
    required this.bottomMargin,
  }) : super(key: key);

  final double topMargin;
  final double bottomMargin;

  @override
  State<AppSubscribeCard> createState() => _AppSubscribeCardState();
}

class _AppSubscribeCardState extends State<AppSubscribeCard> {
  final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
  final bool isIapAvailable = PagesUtilFunctions.isIapAvailable();

  @override
  Widget build(BuildContext context) {
    if (isUserSubscribed || !isIapAvailable) {
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
                  vertical: AppPadding.padding_12,
                  horizontal: AppPadding.padding_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocale.of().subscribeDialogTitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_8,
                    ),
                    Text(
                      "Subscribe to Mehaleye and get unlimited access to all streams and downloads.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (AppFontSizes.font_size_10 - 1).sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: AppMargin.margin_12,
                    ),
                    AppBouncingButton(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterPaths.subscriptionRoute,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.padding_32 * 2,
                          vertical: AppPadding.padding_12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.completelyBlack,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: AppColors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Text(
                          "Try for free".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: (AppFontSizes.font_size_10 - 1).sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    )
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
