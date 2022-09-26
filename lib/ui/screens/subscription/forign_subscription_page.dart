import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_page_bloc/iap_subscription_page_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/screens/subscription/widgets/offering_card.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ForeignSubscriptionPage extends StatefulWidget {
  const ForeignSubscriptionPage({Key? key}) : super(key: key);

  @override
  State<ForeignSubscriptionPage> createState() =>
      _ForeignSubscriptionPageState();
}

class _ForeignSubscriptionPageState extends State<ForeignSubscriptionPage> {
  @override
  void initState() {
    ///LOAD ALL IN APP SUBSCRIPTIONS FROM REVENUE CAT
    BlocProvider.of<IapSubscriptionPageBloc>(context).add(
      LoadIapSubscriptionOfferingsEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IapSubscriptionPageBloc, IapSubscriptionPageState>(
      builder: (context, state) {
        if (state is IapSubscriptionLoadingState) {
          return buildPageLoading();
        }
        if (state is IapNotAvailableErrorState) {
          return buildNotAvailable();
        }
        if (state is IapSubscriptionLoadedState) {
          return buildPageLoaded(
            state.subscriptionOfferingsList,
          );
        }
        if (state is IapSubscriptionLoadingErrorState) {
          return buildPageError();
        }
        return buildPageLoading();
      },
    );
  }

  Widget buildPageLoaded(
      List<IapSubscriptionOfferings> subscriptionOfferingsList) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          ///PLANS LIST
          buildSliverList(subscriptionOfferingsList),

          ///PLANS INFO
          buildPlansInfo(),

          ///BUILD APP TERMS INFO FOR IOS DEVICES
          buildTermsInfo(),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildSliverList(
      List<IapSubscriptionOfferings> subscriptionOfferingsList) {
    return SliverToBoxAdapter(
      child: ListView.builder(
        itemCount: subscriptionOfferingsList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return OfferingCard(
            subscriptionOfferings: subscriptionOfferingsList.elementAt(
              index,
            ),
          );
        },
      ),
    );
  }

  SliverToBoxAdapter buildPlansInfo() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: AppMargin.margin_32,
          ),
          Text(
            AppLocale.of().allPlansInclude,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().unlimitedStreamingAllMezmurs,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_6,
              ),
              Icon(
                FlutterRemix.checkbox_circle_fill,
                color: AppColors.green,
                size: AppIconSizes.icon_size_16,
              ),
            ],
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().unlimitedDownloadOffline,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_6,
              ),
              Icon(
                FlutterRemix.checkbox_circle_fill,
                color: AppColors.green,
                size: AppIconSizes.icon_size_16,
              ),
            ],
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().highQualityAudio,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: AppMargin.margin_6,
              ),
              Icon(
                FlutterRemix.checkbox_circle_fill,
                color: AppColors.green,
                size: AppIconSizes.icon_size_16,
              ),
            ],
          ),
          SizedBox(
            height: AppMargin.margin_32,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildTermsInfo() {
    return SliverToBoxAdapter(
      child: Platform.isIOS
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: AppIconSizes.icon_size_48,
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_dxwu3xu0.json',
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_6,
                  ),
                  Text(
                    'All payments will be paid through your iTunes Account and may be managed under Account Settings after the initial payment. Subscription payments will automatically renew unless deactivated at least 24-hours before the end of the current cycle. Your account will be charged for renewal at least 24-hours prior to the end of the current cycle. Cancellations are incurred by disabling auto-renewal.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (AppFontSizes.font_size_8 + 1).sp,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_20,
                  ),
                  TextButton(
                    onPressed: () {
                      launch('https://meleket.net/term-of-service.html');
                    },
                    child: Text(
                      'Terms of Service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      launch('https://meleket.net/privacy.html');
                    },
                    child: Text(
                      'Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(),
    );
  }

  Widget buildNotAvailable() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.padding_32),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
              vertical: AppPadding.padding_16),
          decoration: BoxDecoration(
            color: AppColors.orange2,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            AppLocale.of().subscriptionNotAvlavableMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPageLoading() {
    return AppLoading(
      size: AppValues.loadingWidgetSize,
    );
  }

  Widget buildPageError() {
    return AppError(
      bgWidget: AppLoading(
        size: AppValues.loadingWidgetSize,
      ),
      onRetry: () {
        ///LOAD ALL IN APP SUBSCRIPTIONS FROM REVENUE CAT
        BlocProvider.of<IapSubscriptionPageBloc>(context).add(
          LoadIapSubscriptionOfferingsEvent(),
        );
      },
    );
  }
}
