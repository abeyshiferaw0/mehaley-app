import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class SignUpCircleButton extends StatelessWidget {
  const SignUpCircleButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.userLoginType,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final String icon;
  final UserLoginType userLoginType;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      shrinkRatio: 5,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: AppColors.completelyBlack.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            padding: EdgeInsets.all(AppPadding.padding_20),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoadingState) {
                  if (state.userLoginType == userLoginType) {
                    return Container(
                      width: AppIconSizes.icon_size_24,
                      height: AppIconSizes.icon_size_24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.darkGrey,
                      ),
                    );
                  } else {
                    return getButtonIcon();
                  }
                } else {
                  return getButtonIcon();
                }
              },
            ),
          ),
          SizedBox(
            height: AppMargin.margin_8,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget getButtonIcon() {
    return SvgPicture.asset(
      icon,
      width: AppIconSizes.icon_size_24,
      height: AppIconSizes.icon_size_24,
    );
  }
}
