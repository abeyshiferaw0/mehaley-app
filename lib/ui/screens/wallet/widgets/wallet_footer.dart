import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_bill_status_bloc/wallet_bill_status_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_page_bloc/wallet_page_bloc.dart';
import 'package:mehaley/business_logic/blocs/wallet_bloc/wallet_recharge_initial_bloc/wallet_recharge_initial_bloc.dart';
import 'package:mehaley/business_logic/cubits/wallet/fresh_wallet_bill_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/screens/wallet/dialogs/dialog_wallet_recharge_initial.dart';
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
                      ///GET PROVIDERS BEFORE PASSING BY VALUE
                      WalletPageBloc walletPageBloc =
                          BlocProvider.of<WalletPageBloc>(context);
                      FreshWalletBillCubit freshWalletBillCubit =
                          BlocProvider.of<FreshWalletBillCubit>(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => WalletRechargeInitialBloc(
                                  walletDataRepository:
                                      AppRepositories.walletDataRepository,
                                ),
                              ),
                              BlocProvider.value(value: walletPageBloc),
                              BlocProvider.value(value: freshWalletBillCubit),
                            ],
                            child: DialogWalletRechargeInitial(),
                          );
                        },
                      );
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
                          "Recharge Wallet".toUpperCase(),
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
            onTap: () {},
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
                    "Help".toUpperCase(),
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
