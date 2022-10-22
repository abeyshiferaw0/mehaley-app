import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/in_app_purchases/iap_subscription_page_bloc/iap_subscription_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_subscription_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bar/subscription_app_bar.dart';
import 'package:mehaley/ui/screens/subscription/forign_subscription_page.dart';
import 'package:mehaley/ui/screens/subscription/local_subscription_page.dart';
import 'package:mehaley/ui/screens/subscription/widgets/iap_subscription_restoring_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

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

  late SubscriptionPageUiType subscriptionPageUiType;

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

    ///GET
    subscriptionPageUiType = PagesUtilFunctions.getSubscriptionPageUiType();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorMapper.getPagesBgColor(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: AppMargin.margin_38,
              ),

              ///APP BAR (MAKE RESTORE BUTTON VISIBLE IF IAP IS AVAILABLE ONLY)
              SubscriptionAppBar(
                showRestoreButton: PagesUtilFunctions.isIapAvailable(),
              ),

              SizedBox(
                height: AppMargin.margin_32,
              ),

              ///HEADER TITLE
              buildHeaderTitle(),

              ///IF IAP IS AVAILABLE AND USERS PHONE NUMBER IS ETHIOPIAN
              ///SHOW BOTH LOCAL AND FOREIGN SUBSCRIPTIONS
              if (subscriptionPageUiType ==
                  SubscriptionPageUiType.BOTH_WITH_TABS)
                Expanded(
                  child: buildBothWithTabs(),
                ),

              ///IF IAP IS NOT AVAILABLE AND USERS PHONE NUMBER IS ETHIOPIAN
              ///SHOW ONLY LOCAL SUBSCRIPTIONS
              if (subscriptionPageUiType == SubscriptionPageUiType.ONLY_LOCAL)
                Expanded(
                  child: LocalSubscriptionPage(),
                ),

              ///IF IAP IS AVAILABLE AND USERS PHONE NUMBER IS NOT ETHIOPIAN
              ///SHOW ONLY FOREIGN SUBSCRIPTIONS
              if (subscriptionPageUiType == SubscriptionPageUiType.ONLY_FOREIGN)
                Expanded(
                  child: ForeignSubscriptionPage(),
                ),

              ///IF IAP IS NOT AVAILABLE AND USERS PHONE NUMBER IS NOT ETHIOPIAN
              ///SHOW SUBSCRIPTIONS NOT AVAILABLE MESSAGE
              if (subscriptionPageUiType ==
                  SubscriptionPageUiType.NOT_AVAILABLE)
                Expanded(
                  child: buildNotAvailable(),
                ),
            ],
          ),

          ///IN APP RESTORING LOADING UI
          IapSubscriptionRestoringWidget(),
        ],
      ),
    );
  }

  Widget buildBothWithTabs() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SizedBox(
            height: AppMargin.margin_32,
          ),
          TabBar(
              unselectedLabelColor: AppColors.orange,
              labelColor: AppColors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.orange,
              ),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.orange,
                        width: 1,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocale.of().local,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_12.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.orange, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocale.of().foreign,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
          Expanded(
            child: TabBarView(
              children: [
                LocalSubscriptionPage(),
                ForeignSubscriptionPage(),
              ],
            ),
          )
        ],
      ),
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

  Container buildHeaderTitle() {
    return Container(
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
    );
  }
}
