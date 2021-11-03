import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elf_play/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:elf_play/business_logic/cubits/connectivity_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class NoInternetHeader extends StatelessWidget {
  const NoInternetHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityResult>(
      builder: (context, state) {
        if (state == ConnectivityResult.none) {
          return buildNoInternetHeader(context);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Container buildNoInternetHeader(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_32 * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your offline",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            "No internet connection".toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          AppBouncingButton(
            onTap: () {
              BlocProvider.of<BottomBarCubit>(context).changeScreen(
                BottomBarPages.LIBRARY,
              );
              //////////////////////////////////////////////////////////////////////
              //////////////////////////////////////////////////////////////////////
              Navigator.pushNamed(
                context,
                AppRouterPaths.libraryRoute,
                arguments: ScreenArguments(
                  args: {AppValues.isLibraryForOffline: true},
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_16,
                vertical: AppPadding.padding_8,
              ),
              child: Text(
                "Go to downloads to listen offline",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
