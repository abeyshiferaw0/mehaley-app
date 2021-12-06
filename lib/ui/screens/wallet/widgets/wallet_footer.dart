import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class WalletFooter extends StatelessWidget {
  const WalletFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_12,
        vertical: AppPadding.padding_12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.completelyBlack.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<WalletBillStatusBloc, WalletBillStatusState>(
              builder: (context, state) {
                return AppBouncingButton(
                  disableBouncing: (state is WalletBillStatusLoadingState),
                  onTap: () {
                    if (!(state is WalletBillStatusLoadingState)) {
                      PagesUtilFunctions.openWalletRechargeInitialDialog(
                          context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding_12,
                      vertical: AppPadding.padding_12,
                    ),
                    decoration: BoxDecoration(
                      color: (state is WalletBillStatusLoadingState)
                          ? AppColors.grey
                          : AppColors.darkOrange,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FlutterRemix.add_line,
                          size: AppIconSizes.icon_size_20,
                          color: AppColors.white,
                        ),
                        SizedBox(width: AppMargin.margin_12),
                        Text(
                          AppLocale.of().rechargeYourWallet.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: AppMargin.margin_12),
          AppBouncingButton(
            onTap: () {
              PagesUtilFunctions.goToHowToPayPage(
                context,
                AppValues.howToPayHelpGeneralUrl,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_24,
                vertical: AppPadding.padding_12,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterRemix.question_line,
                    size: AppIconSizes.icon_size_20,
                    color: AppColors.darkGrey,
                  ),
                  SizedBox(width: AppMargin.margin_12),
                  Text(
                    AppLocale.of().help.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
