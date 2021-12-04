import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:intl/intl.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_cancel_bloc/wallet_bill_cancel_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/payment/webirr_bill.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/copy_button.dart';
import 'package:mehaley/ui/screens/wallet/dialogs/dialog_cancel_bill.dart';
import 'package:mehaley/util/network_util.dart';
import 'package:sizer/sizer.dart';

class WalletActiveBill extends StatefulWidget {
  const WalletActiveBill({Key? key, required this.activeBill})
      : super(key: key);

  final WebirrBill activeBill;

  @override
  State<WalletActiveBill> createState() => _WalletActiveBillState();
}

class _WalletActiveBillState extends State<WalletActiveBill>
    with TickerProviderStateMixin {
  late MaskedTextController maskedTextController;

  late AnimationController _controller;

  @override
  void initState() {
    ///INIT ANIMATION CONTROLLER
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    maskedTextController = new MaskedTextController(
        text: widget.activeBill.wbcCode, mask: '000 000 000');
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
      padding: EdgeInsets.all(
        AppPadding.padding_16,
      ),
      margin: EdgeInsets.only(
        top: AppMargin.margin_16,
        left: AppMargin.margin_16,
        right: AppMargin.margin_16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.orange),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.completelyBlack.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          buildCardHeader(),
          SizedBox(
            height: AppMargin.margin_12,
          ),
          buildCardMsg(),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          buildBillInfo(),
          SizedBox(
            height: AppMargin.margin_20,
          ),
          buildCardButtons(),
        ],
      ),
    );
  }

  Row buildCardButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocConsumer<WalletBillStatusBloc, WalletBillStatusState>(
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
              ///SHOW LOADING BUTTON IF CHECKING BILL STATUS
              return buildBillStatusLoadingButton(
                title: AppLocale.of().checkingBillStatus,
                icon: FlutterRemix.refresh_line,
                color: AppColors.darkOrange,
              );
            } else {
              return buildBillButton(
                title: AppLocale.of().checkBillStatus,
                onTap: () {
                  checkBillStatus();
                },
                icon: FlutterRemix.refresh_line,
                color: AppColors.darkOrange,
              );
            }
          },
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        buildBillButton(
          title: AppLocale.of().cancelBill,
          onTap: () {
            cancelBill();
          },
          icon: FlutterRemix.close_line,
          color: AppColors.errorRed,
        ),
      ],
    );
  }

  Expanded buildBillButton({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: AppBouncingButton(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: color),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_16,
            vertical: AppPadding.padding_6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppIconSizes.icon_size_16,
                color: color,
              ),
              SizedBox(
                width: AppPadding.padding_4,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_8.sp,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildBillStatusLoadingButton({
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(color: color),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
          vertical: AppPadding.padding_6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Icon(
                icon,
                size: AppIconSizes.icon_size_16,
                color: color,
              ),
            ),
            SizedBox(
              width: AppPadding.padding_4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildBillInfo() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().amount,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_4,
            ),
            Text(
              '${widget.activeBill.amount} ${AppLocale.of().birr}',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        SizedBox(
          width: AppMargin.margin_32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().unpaidBillCode,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  maskedTextController.text,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                CopyButton(
                  copyText: widget.activeBill.wbcCode,
                  title: AppLocale.of().copyCode,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Text buildCardMsg() {
    return Text(
      AppLocale.of().activeBillMsg(
        date: DateFormat('dd/MM/yyy')
            .format(widget.activeBill.dateCreated)
            .toString(),
      ),
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_8.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.txtGrey,
      ),
    );
  }

  Row buildCardHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocale.of().rechargeYourWallet.toUpperCase(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(width: AppMargin.margin_16),
        AppBouncingButton(
          onTap: () {},
          child: Text(
            AppLocale.of().howToPay,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blue,
            ),
          ),
        ),
      ],
    );
  }

  void checkBillStatus() async {
    bool isNetAvailable = await NetworkUtil.isInternetAvailable();
    if (isNetAvailable) {
      BlocProvider.of<WalletBillStatusBloc>(context).add(
        CheckWalletBillStatusEvent(),
      );
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
  }

  void cancelBill() async {
    bool isNetAvailable = await NetworkUtil.isInternetAvailable();
    if (isNetAvailable) {
      showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: DialogCancelBill(
              mainButtonText: AppLocale.of().cancelBill.toUpperCase(),
              cancelButtonText: AppLocale.of().cancel.toUpperCase(),
              titleText: AppLocale.of().areYouSureUWantToCancelBill,
              onCancel: () {
                BlocProvider.of<WalletBillCancelBloc>(context).add(
                  CancelWalletBillEvent(
                    oldBill: widget.activeBill,
                  ),
                );
              },
            ),
          );
        },
      );
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
  }
}
