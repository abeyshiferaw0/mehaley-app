import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/dialog/dialog_log_out.dart';
import 'package:sizer/sizer.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppBouncingButton(
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) {
              return DialogLogOut(
                onLogOut: () {
                  BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                },
              );
            },
          );
        },
        shrinkRatio: 3,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppMargin.margin_32,
            vertical: AppMargin.margin_12,
          ),
          decoration: BoxDecoration(
            color: ColorMapper.getBlack(),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            AppLocale.of().logOut.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w500,
              color: ColorMapper.getWhite(),
            ),
          ),
        ),
      ),
    );
  }
}
