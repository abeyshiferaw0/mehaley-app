import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_cancel_bloc/wallet_bill_cancel_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_active_bill.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_footer.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_history_item.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_sliver_delegates.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_title.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import 'dialogs/dialog_bill_cancled.dart';
import 'dialogs/dialog_bill_confirmed.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  @override
  void initState() {
    BlocProvider.of<WalletPageBloc>(context).add(
      LoadWalletPageEvent(),
    );

    ///ADD OBSERVER IF APP IS RESUMED
    WidgetsBinding.instance!.addObserver(this);
    BlocProvider.of<FreshWalletBillCubit>(context).showPaymentConfirmed(null);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ///REFRESH PAGE IF APP RESUMED WITH THIS BAGE
      BlocProvider.of<WalletPageBloc>(context).add(
        LoadWalletPageEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.pagesBgColor,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<FreshWalletBillCubit, WebirrBill?>(
              listener: (context, state) {
                if (state != null) {
                  ///SHOW FRESH BILL DIALOG
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DialogBillConfirmed(
                        freshBill: state,
                      );
                    },
                  );
                }
              },
            ),
            BlocListener<WalletBillStatusBloc, WalletBillStatusState>(
              listener: (context, state) {
                if (state is WalletBillStatusLoadingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildDownloadMsgSnackBar(
                      bgColor: AppColors.darkGrey,
                      isFloating: true,
                      msg: AppLocale.of().billStatusFailedMsg,
                      txtColor: AppColors.white,
                      icon: FlutterRemix.wifi_off_line,
                      iconColor: AppColors.errorRed,
                    ),
                  );
                }
                if (state is WalletBillStatusLoadedState) {
                  ///UPDATE WALLET PAGE FROM CHECK BILL STATUS REQUEST
                  BlocProvider.of<WalletPageBloc>(context).add(
                    UpdateWalletPageEvent(walletPageData: state.walletPageData),
                  );

                  if (state.walletPageData.activeBill != null) {
                    ///BILL NOT PAID YET MESSAGE
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildAppSnackBar(
                        bgColor: AppColors.darkGrey,
                        isFloating: true,
                        msg: AppLocale.of().billNotPaidYetMsg,
                        txtColor: AppColors.white,
                      ),
                    );
                  }

                  if (state.walletPageData.freshBill != null) {
                    ///SHOW FRESH BILL DIALOG
                    BlocProvider.of<FreshWalletBillCubit>(context)
                        .showPaymentConfirmed(
                      state.walletPageData.freshBill!,
                    );
                  }
                }
              },
            ),
            BlocListener<WalletBillCancelBloc, WalletBillCancelState>(
              listener: (context, state) {
                if (state is CancelWalletBillLoadingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildDownloadMsgSnackBar(
                      bgColor: AppColors.darkGrey,
                      isFloating: true,
                      msg: AppLocale.of().billCancelFailedMsg,
                      txtColor: AppColors.white,
                      icon: FlutterRemix.wifi_off_line,
                      iconColor: AppColors.errorRed,
                    ),
                  );
                }

                if (state is CancelWalletBillLoadedState) {
                  ///UPDATE WALLET PAGE FROM CHECK BILL STATUS REQUEST
                  BlocProvider.of<WalletPageBloc>(context).add(
                    UpdateWalletPageEvent(walletPageData: state.walletPageData),
                  );

                  if (state.walletPageData.freshBill != null) {
                    if (state.walletPageData.freshBill!.webirrTransactionId ==
                        state.oldBill.webirrTransactionId)

                      ///SHOW BILL ALREADY PAID MESSAGE IF CANCELED BILL ID AND FRESH BILL ID IS SAME
                      ScaffoldMessenger.of(context).showSnackBar(
                        buildAppSnackBar(
                          bgColor: AppColors.darkGrey,
                          isFloating: true,
                          msg: AppLocale.of().billAlreadyPaidMsg,
                          txtColor: AppColors.white,
                        ),
                      );

                    ///SHOW FRESH BILL DIALOG
                    BlocProvider.of<FreshWalletBillCubit>(context)
                        .showPaymentConfirmed(
                      state.walletPageData.freshBill!,
                    );
                  } else {
                    ///SHOW Bill CANCELED DIALOG
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Builder(
                          builder: (context) {
                            return Center(
                              child: DialogBillCancelled(),
                            );
                          },
                        );
                      },
                    );
                  }
                }
              },
            ),
            BlocListener<WalletPageBloc, WalletPageState>(
              listener: (context, state) {
                if (state is WalletPageLoadedState) {
                  if (state.showFreshBillDialog) {
                    ///SHOW FRESH BILL DIALOG
                    BlocProvider.of<FreshWalletBillCubit>(context)
                        .showPaymentConfirmed(
                      state.walletPageData.freshBill!,
                    );
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<WalletBillCancelBloc, WalletBillCancelState>(
            builder: (context, billState) {
              return Stack(
                children: [
                  BlocBuilder<WalletPageBloc, WalletPageState>(
                    builder: (context, state) {
                      if (state is WalletPageLoadingState) {
                        return buildPageLoading();
                      }
                      if (state is WalletPageLoadingErrorState) {
                        return buildPageLoadingError();
                      }
                      if (state is WalletPageLoadedState) {
                        return buildPageLoaded(state.walletPageData);
                      }
                      return buildPageLoading();
                    },
                  ),

                  ///SHOW DIM LOADING WHEN BILL CANCEL LOADING STATE
                  (billState is CancelWalletBillLoadingState)
                      ? buildBillCancelLoading()
                      : SizedBox(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: AppColors.white,
      shadowColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          FlutterRemix.arrow_left_line,
          size: AppIconSizes.icon_size_24,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
      title: Text(
        AppLocale.of().appWallet,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
      actions: [
        BlocBuilder<WalletBillStatusBloc, WalletBillStatusState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                if (!(state is WalletBillStatusLoadingState)) {
                  //TODO
                  ///SAME AS FOOTER RECHARGE BUTTON IF NOT REFRESHING
                }
              },
              icon: Icon(
                FlutterRemix.add_line,
                size: AppIconSizes.icon_size_24,
                color: AppColors.black,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildPageLoading() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.pagesBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        shadowColor: AppColors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FlutterRemix.arrow_left_line,
            size: AppIconSizes.icon_size_24,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocale.of().appWallet,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ),
      body: AppLoading(size: AppValues.loadingWidgetSize * 0.8),
    );
  }

  Widget buildBillCancelLoading() {
    return Container(
      color: AppColors.completelyBlack.withOpacity(0.5),
      width: ScreenUtil(context: context).getScreenWidth(),
      height: ScreenUtil(context: context).getScreenHeight(),
      child: Center(
        child: AppLoading(size: AppValues.loadingWidgetSize * 0.8),
      ),
    );
  }

  Widget buildPageLoadingError() {
    return AppError(
      bgWidget: buildPageLoading(),
      onRetry: () {
        BlocProvider.of<WalletPageBloc>(context).add(
          LoadWalletPageEvent(),
        );
      },
    );
  }

  NestedScrollView buildPageLoaded(WalletPageData walletPageData) {
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          buildSliverAppBar(context),
          SliverPersistentHeader(
            pinned: false,
            floating: true,
            delegate: WalletPageHeadersDelegate(
              headerOneHeight:
                  ScreenUtil(context: context).getScreenHeight() * 0.11,
              headerTwoHeight:
                  ScreenUtil(context: context).getScreenHeight() * 0.15,
              walletPageData: walletPageData,
            ),
          ),
        ];
      },
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ///SHOW ACTIVE BILL IF EXISTS
                  walletPageData.activeBill != null
                      ? WalletActiveBill(
                          activeBill: walletPageData.activeBill!,
                        )
                      : SizedBox(),
                  WalletTitle(),
                  ListView.separated(
                    itemCount: 23,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return WalletHistoryItem();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: AppMargin.margin_16,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          WalletFooter(),
        ],
      ),
    );
  }
}
