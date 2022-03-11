import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_page_bloc/iap_subscription_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_subscription_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/subscription_offerings.dart';
import 'package:mehaley/ui/common/app_bar/subscription_app_bar.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/dialog/dialog_subscription_not_available.dart';
import 'package:mehaley/ui/screens/subscription/widgets/iap_subscription_restoring_widget.dart';
import 'package:mehaley/ui/screens/subscription/widgets/subscription_sliver_header_Delegate.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import 'widgets/offering_card.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with RouteAware {
  ///DEBUG
  // List<SubscriptionOfferings> subscriptionOfferingsList = [
  //   SubscriptionOfferings(
  //     title: "Weekly Subscription",
  //     description:
  //         "Get access to Unlimited streaming and download with mehaleye weekly subscription",
  //     priceDescription: "3 days free\nThen 2.99/week",
  //     savingDescription: "",
  //     subTitle: "No Commitment, cancel at any time",
  //     textColor: HexColor("#ffffff"),
  //     color1: HexColor("#3CB5AC"),
  //     color2: HexColor("#4674E7"),
  //     color3: HexColor("#845AE8"),
  //   ),
  //   SubscriptionOfferings(
  //     title: "Monthly Subscription",
  //     description:
  //         "Get access to Unlimited streaming and download with mehaleye monthly subscription",
  //     priceDescription: "7 days free\nThen 9.99/month ",
  //     savingDescription: "(Save  up to 10% 2.99/week)",
  //     subTitle: "No Commitment, cancel at any time",
  //     textColor: HexColor("#ffffff"),
  //     color1: HexColor("#FDA823"),
  //     color2: HexColor("#EC7820"),
  //     color3: HexColor("#E34C13"),
  //   ),
  //   SubscriptionOfferings(
  //     title: "3 Months Discount Subscription",
  //     description:
  //         "Get access to Unlimited streaming and download with mehaleye weekly subscription",
  //     priceDescription: "1 month free\nThen 24.99/3 months",
  //     savingDescription: "(Save  up to 10% 2.99/week)",
  //     subTitle: "No Commitment, cancel at any time",
  //     textColor: HexColor("#000000"),
  //     color1: HexColor("#E5A238"),
  //     color2: HexColor("#FCD589"),
  //     color3: HexColor("#EEC87E"),
  //   ),
  // ];

  void didChangeDependencies() {
    super.didChangeDependencies();
    //SUBSCRIBE TO ROUTH OBSERVER
    AppRouterPaths.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    BlocProvider.of<BottomBarCubit>(context)
        .changeScreen(BottomBarPages.SUBSCRIPTION);
    BlocProvider.of<BottomBarSubscriptionCubit>(context).setPageShowing(true);
  }

  @override
  void didPushNext() {
    BlocProvider.of<BottomBarSubscriptionCubit>(context).setPageShowing(false);
    super.didPushNext();
  }

  @override
  void didPop() {
    BlocProvider.of<BottomBarSubscriptionCubit>(context).setPageShowing(false);
    super.didPop();
  }

  @override
  void dispose() {
    AppRouterPaths.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<BottomBarCubit>(context)
        .changeScreen(BottomBarPages.SUBSCRIPTION);
    BlocProvider.of<BottomBarSubscriptionCubit>(context).setPageShowing(true);

    ///CHANGE BOTTOM BAR TO SUBSCRIPTION PAGE
    BlocProvider.of<BottomBarCubit>(context).changeScreen(
      BottomBarPages.SUBSCRIPTION,
    );

    ///LOAD ALL IN APP SUBSCRIPTIONS FROM REVENUE CAT
    BlocProvider.of<IapSubscriptionPageBloc>(context).add(
      LoadIapSubscriptionOfferingsEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      body: Stack(
        children: [
          BlocConsumer<IapSubscriptionPageBloc, IapSubscriptionPageState>(
            listener: (context, state) {
              if (state is IapNotAvailableErrorState) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogSubscribeNotAvailable();
                  },
                );

                ///GO BACK TO PRE PAGE
                Navigator.pop(context);
              }
            },
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
          ),

          ///IN APP RESTORING LOADING UI
          IapSubscriptionRestoringWidget(),
        ],
      ),
    );
  }

  Widget buildNotAvailable() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: AppMargin.margin_24,
          ),

          ///APP BAR
          SubscriptionAppBar(
            showRestoreButton: false,
          ),

          ///NOT AVAILABLE MESSAGE
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocale.of().subscriptionNotAvlavableMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorMapper.getTxtGrey(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageLoaded(
      List<SubscriptionOfferings> subscriptionOfferingsList) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppMargin.margin_24,
            ),
          ),

          ///APP BAR
          SliverToBoxAdapter(
            child: SubscriptionAppBar(
              showRestoreButton: true,
            ),
          ),

          ///HEADER TITLE
          buildHeaderTitle(),

          ///PLANS LIST
          buildSliverList(subscriptionOfferingsList),

          ///PLANS INFO
          buildPlansInfo(),
        ],
      ),
    );
  }

  Widget buildPageLoading() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: AppMargin.margin_16,
          ),
          SubscriptionAppBar(
            showRestoreButton: false,
          ),
          Expanded(
            child: AppLoading(
              size: AppValues.loadingWidgetSize,
            ),
          )
        ],
      ),
    );
  }

  Widget buildPageError() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: AppMargin.margin_16,
          ),
          SubscriptionAppBar(
            showRestoreButton: false,
          ),
          Expanded(
            child: AppError(
              bgWidget: AppLoading(
                size: AppValues.loadingWidgetSize,
              ),
              onRetry: () {
                ///LOAD ALL IN APP SUBSCRIPTIONS FROM REVENUE CAT
                BlocProvider.of<IapSubscriptionPageBloc>(context).add(
                  LoadIapSubscriptionOfferingsEvent(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  SliverPersistentHeader buildHeaderTitle() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SubscriptionSliverHeaderDelegate(
        height: ScreenUtil(context: context).getScreenHeight() * 0.15,
        child: Container(
          color: ColorMapper.getPagesBgColor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().ourPlans.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: ColorMapper.getBlack(),
                ),
              ),
              SizedBox(
                height: AppMargin.margin_8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_24,
                ),
                child: Text(
                  AppLocale.of().subscribeDialogMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorMapper.getTxtGrey(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSliverList(
      List<SubscriptionOfferings> subscriptionOfferingsList) {
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
              color: ColorMapper.getBlack(),
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
                  color: ColorMapper.getBlack(),
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
                  color: ColorMapper.getBlack(),
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
                  color: ColorMapper.getBlack(),
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
}
