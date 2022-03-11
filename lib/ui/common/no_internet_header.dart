import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/bottom_bar_cubit/bottom_bar_cubit.dart';
import 'package:mehaley/business_logic/cubits/connectivity_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
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
          //return buildNoInternetHeader(context);
        }
      },
    );
  }

  Container buildNoInternetHeader(context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: AppPadding.padding_24 * 2,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().yourOffline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_14.sp,
                fontWeight: FontWeight.w600,
                color: ColorMapper.getBlack(),
              ),
            ),
            SizedBox(height: AppMargin.margin_16),
            Text(
              AppLocale.of().noInternetMsg.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w600,
                color: ColorMapper.getGrey(),
              ),
            ),
            SizedBox(height: AppMargin.margin_16),
            Padding(
              padding: const EdgeInsets.all(AppPadding.padding_16),
              child: AppBouncingButton(
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
                    color: ColorMapper.getBlack(),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_16,
                    vertical: AppPadding.padding_8,
                  ),
                  child: Text(
                    AppLocale.of().goToDownloadsMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorMapper.getLightGrey(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
