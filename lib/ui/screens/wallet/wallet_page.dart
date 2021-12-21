import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_cancel_bloc/wallet_bill_cancel_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_history_bloc/wallet_history_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_gift_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/data_providers/wallet_data_provider.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/data/models/payment/wallet_history_group.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_active_bill.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_footer.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_history_grop_item.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_history_pagination_error_widget.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_history_shimmer.dart';
import 'package:mehaley/ui/screens/wallet/widgets/wallet_sliver_delegates.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';

import 'dialogs/dialog_bill_cancled.dart';

class WalletPage extends StatefulWidget {
  const WalletPage(
      {Key? key,
      required this.startRechargeProcess,
      required this.showHowToPayOnInit,
      required this.copyCodeOnInit,
      required this.codeToCopy})
      : super(key: key);

  final bool startRechargeProcess;
  final bool showHowToPayOnInit;
  final bool copyCodeOnInit;
  final String codeToCopy;

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with WidgetsBindingObserver {
  //PAGINATION CONTROLLER
  final PagingController<int, WalletHistoryGroup> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    BlocProvider.of<WalletPageBloc>(context).add(
      LoadWalletPageEvent(),
    );

    ///FETCH PAGINATED WALLET HISTORY WITH PAGINATED CONTROLLER
    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<WalletHistoryBloc>(context).add(
          LoadWalletHistoryPaginatedEvent(
            pageSize: AppValues.pageSize,
            page: pageKey,
          ),
        );
      },
    );

    ///ADD OBSERVER IF APP IS RESUMED
    WidgetsBinding.instance!.addObserver(this);

    ///IF startRechargeProcess IS NOT NULL AND IF TRUE SHOW RECHARGE DIALOG
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        if (widget.startRechargeProcess) {
          PagesUtilFunctions.openWalletRechargeInitialDialog(context);
        }
        if (widget.showHowToPayOnInit) {
          PagesUtilFunctions.goToHowToPayPage(
            context,
            AppValues.howToPayHelpGeneralUrl,
          );
        }
        if (widget.copyCodeOnInit) {
          ///COPY TEXT TO CLIP BOARD
          Clipboard.setData(
            ClipboardData(text: widget.codeToCopy),
          ).then(
            (value) {
              ///SHOW COPED SNACK
              // ScaffoldMessenger.of(context).showSnackBar(
              //   buildAppSnackBar(
              //     bgColor: AppColors.black.withOpacity(0.9),
              //     isFloating: false,
              //     msg: AppLocale.of().copiedToClipboard,
              //     txtColor: AppColors.white,
              //   ),
              // );
              showSimpleNotification(
                Container(
                  padding: EdgeInsets.all(AppPadding.padding_8),
                  color: AppColors.white,
                  child: Center(
                    child: Text(
                      AppLocale.of().copiedToClipboard,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSizes.font_size_10.sp,
                      ),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                background: AppColors.white,
                duration: Duration(milliseconds: 1200),
              );
            },
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    ///REFRESH PAGE IF APP RESUMED WITH THIS BAGE
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        if (state == AppLifecycleState.resumed) {
          BlocProvider.of<WalletPageBloc>(context).add(
            LoadWalletPageEvent(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pagesBgColor,
      body: MultiBlocListener(
        listeners: [
          //todo refractory listeners to there own class
          BlocListener<WalletHistoryBloc, WalletHistoryState>(
            listener: (context, state) {
              if (state is WalletHistoryPaginatedLoaded) {
                final isLastPage =
                    state.walletHistoryList.length < AppValues.pageSize;

                ///GROUP WALLET HISTORY BY DATE
                List<WalletHistoryGroup> walletHistoryGroupList =
                    WalletDataProvider()
                        .groupWalletHistory(state.walletHistoryList);

                if (isLastPage) {
                  _pagingController.appendLastPage(walletHistoryGroupList);
                } else {
                  final nextPageKey = state.page + 1;
                  _pagingController.appendPage(
                      walletHistoryGroupList, nextPageKey);
                }
              }
              if (state is WalletHistoryPaginatedLoadingError) {
                _pagingController.error = AppLocale.of().networkError;
              }
            },
          ),
          BlocListener<FreshWalletBillCubit, WebirrBill?>(
            listener: (context, state) {
              if (state != null) {
                ///WHEN NEW FRESH PAYMENT ALSO REFRESH WALLET HISTORY
                _pagingController.refresh();
              }
            },
          ),
          BlocListener<WalletBillStatusBloc, WalletBillStatusState>(
            listener: (context, state) {
              if (state is WalletBillStatusLoadingErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildDownloadMsgSnackBar(
                    bgColor: AppColors.white,
                    isFloating: true,
                    msg: AppLocale.of().billStatusFailedMsg,
                    txtColor: AppColors.black,
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

                ///SHOW FRESH BILL DIALOG
                if (state.walletPageData.freshBill != null) {
                  BlocProvider.of<FreshWalletBillCubit>(context)
                      .showPaymentConfirmed(
                    state.walletPageData.freshBill!,
                  );
                }

                ///SHOW FRESH GIFT NOTIFICATION
                BlocProvider.of<FreshWalletGiftCubit>(context).showGiftReceived(
                  state.walletPageData.freshWalletGifts,
                );
              }
            },
          ),
          BlocListener<WalletBillCancelBloc, WalletBillCancelState>(
            listener: (context, state) {
              if (state is CancelWalletBillLoadingErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  buildDownloadMsgSnackBar(
                    bgColor: AppColors.white,
                    isFloating: true,
                    msg: AppLocale.of().billCancelFailedMsg,
                    txtColor: AppColors.black,
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

                ///SHOW FRESH GIFT NOTIFICATION
                BlocProvider.of<FreshWalletGiftCubit>(context).showGiftReceived(
                  state.walletPageData.freshWalletGifts,
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
                ///SHOW FRESH BILL DIALOG
                if (state.showFreshBillDialog) {
                  BlocProvider.of<FreshWalletBillCubit>(context)
                      .showPaymentConfirmed(
                    state.walletPageData.freshBill!,
                  );
                }

                ///SHOW FRESH GIFT NOTIFICATION
                if (state.showFreshWalletGifts) {
                  BlocProvider.of<FreshWalletGiftCubit>(context)
                      .showGiftReceived(
                    state.walletPageData.freshWalletGifts,
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
                  PagesUtilFunctions.openWalletRechargeInitialDialog(context);
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

  Column buildPageLoaded(WalletPageData walletPageData) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              ///APP BAR
              buildSliverAppBar(context),

              ///WALLET HEADERS
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: WalletPageHeadersDelegate(
                  headerOneHeight:
                      ScreenUtil(context: context).getScreenHeight() * 0.12,
                  headerTwoHeight:
                      ScreenUtil(context: context).getScreenHeight() * 0.15,
                  walletPageData: walletPageData,
                  onWalletPageRefresh: () {
                    ///WHEN WALLET REFRESH ALSO REFRESH HISTORY
                    _pagingController.refresh();
                  },
                ),
              ),

              ///SHOW ACTIVE BILL IF EXISTS
              SliverToBoxAdapter(
                child: walletPageData.activeBill != null
                    ? WalletActiveBill(
                        activeBill: walletPageData.activeBill!,
                      )
                    : SizedBox(),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ScreenUtil(context: context).getScreenHeight() * 0.02,
                ),
              ),

              ///WALLET HISTORY TITLE
              SliverPersistentHeader(
                floating: true,
                delegate: WalletPageHistoryTitleDelegate(
                  height: ScreenUtil(context: context).getScreenHeight() * 0.08,
                ),
              ),

              ///WALLET HISTORY
              buildWalletHistoryList()
            ],
          ),
        ),
        WalletFooter(),
      ],
    );
  }

  PagedSliverList buildWalletHistoryList() {
    return PagedSliverList<int, WalletHistoryGroup>.separated(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<WalletHistoryGroup>(
        itemBuilder: (context, item, index) {
          return WalletHistoryGroupItem(
            walletHistoryGroup: item,
          );
        },
        noItemsFoundIndicatorBuilder: (context) {
          return buildEmptyHistory();
        },
        newPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
            child: AppLoading(
              size: 50,
              strokeWidth: 3,
            ),
          );
        },
        firstPageProgressIndicatorBuilder: (context) {
          return WalletHistoryShimmer();
        },
        noMoreItemsIndicatorBuilder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppPadding.padding_8),
            child: SizedBox(
              height: 30,
            ),
          );
        },
        newPageErrorIndicatorBuilder: (context) {
          return WalletHistoryPaginationErrorWidget(
            onRetry: () {
              _pagingController.retryLastFailedRequest();
            },
          );
        },
        firstPageErrorIndicatorBuilder: (context) {
          return WalletHistoryPaginationErrorWidget(
            onRetry: () {
              _pagingController.refresh();
            },
          );
        },
      ),
      separatorBuilder: (context, index) => SizedBox(
        height: AppMargin.margin_24,
      ),
    );
  }

  Container buildEmptyHistory() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FlutterRemix.wallet_3_line,
          size: AppIconSizes.icon_size_72,
          color: AppColors.lightGrey.withOpacity(0.8),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32 * 2,
          ),
          child: Text(
            AppLocale.of().noHistory,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: AppColors.txtGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ));
  }
}
