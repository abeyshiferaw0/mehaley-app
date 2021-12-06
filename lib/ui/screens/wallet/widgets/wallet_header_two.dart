import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/wallet_page_data.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/util/network_util.dart';
import 'package:sizer/sizer.dart';

class WalletHeaderTwo extends StatefulWidget {
  const WalletHeaderTwo(
      {Key? key,
      required this.onWalletPageRefresh,
      required this.height,
      required this.walletPageData,
      required this.shrinkPercentage})
      : super(key: key);

  final double height;
  final WalletPageData walletPageData;
  final double shrinkPercentage;
  final VoidCallback onWalletPageRefresh;

  @override
  State<WalletHeaderTwo> createState() => _WalletHeaderTwoState();
}

class _WalletHeaderTwoState extends State<WalletHeaderTwo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    ///INIT ANIMATION CONTROLLER
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      height: widget.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.of().myWalletBalance,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
              SizedBox(
                height: AppPadding.padding_4,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: widget.walletPageData.walletBalance.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  children: [
                    TextSpan(
                      text: ' ${AppLocale.of().birr}',
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(),
          ),
          Tooltip(
            message: AppLocale.of().refreshWalletMsg,
            preferBelow: false,
            margin: EdgeInsets.symmetric(
              horizontal: AppMargin.margin_62,
              vertical: AppMargin.margin_12,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
              vertical: AppPadding.padding_12,
            ),
            child: BlocConsumer<WalletBillStatusBloc, WalletBillStatusState>(
              listener: (context, state) {
                if (state is WalletBillStatusLoadingState) {
                  _controller.forward();
                  _controller.repeat();
                } else {
                  _controller.stop();
                  _controller.reset();
                }
              },
              builder: (context, state) {
                if (state is WalletBillStatusLoadingState) {
                  return buildLoadingButton();
                } else {
                  return buildRefreshButton();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  AppBouncingButton buildRefreshButton() {
    return AppBouncingButton(
      onTap: () async {
        bool isNetAvailable = await NetworkUtil.isInternetAvailable();
        if (isNetAvailable) {
          BlocProvider.of<WalletPageBloc>(context).add(
            RefreshWalletPageEvent(),
          );

          ///SEND CALL BACK OF REFRESH BUTTON
          widget.onWalletPageRefresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            buildDownloadMsgSnackBar(
              bgColor: AppColors.darkGrey,
              isFloating: true,
              msg: AppLocale.of().noInternetMsg,
              txtColor: AppColors.white,
              icon: FlutterRemix.wifi_off_line,
              iconColor: AppColors.errorRed,
            ),
          );
        }
      },
      child: AppCard(
        radius: 100.0,
        child: Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.padding_16,
            vertical: AppPadding.padding_12,
          ),
          child: Row(
            children: [
              Icon(
                FlutterRemix.refresh_line,
                size: AppIconSizes.icon_size_16,
                color: AppColors.black,
              ),
              SizedBox(
                width: AppPadding.padding_8,
              ),
              Text(
                AppLocale.of().refreshWallet.toUpperCase(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppCard buildLoadingButton() {
    return AppCard(
      radius: 100.0,
      child: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_12,
        ),
        child: Row(
          children: [
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Icon(
                FlutterRemix.refresh_line,
                size: AppIconSizes.icon_size_16,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              width: AppPadding.padding_8,
            ),
            Text(
              AppLocale.of().refreshingWallet.toUpperCase(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
