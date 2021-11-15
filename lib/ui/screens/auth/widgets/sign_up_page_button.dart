import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mehaley/business_logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.color,
    required this.isFilled,
    required this.noBorder,
    required this.userLoginType,
    this.icon,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final String? icon;
  final Color color;
  final bool isFilled;
  final bool noBorder;
  final UserLoginType userLoginType;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      shrinkRatio: 5,
      child: Container(
        decoration: BoxDecoration(
          color: isFilled ? color : AppColors.transparent,
          border: noBorder ? null : Border.all(color: color),
          borderRadius: noBorder ? null : BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_12,
          horizontal: AppPadding.padding_16,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    if (state.userLoginType == userLoginType) {
                      return Container(
                        width: AppIconSizes.icon_size_24,
                        height: AppIconSizes.icon_size_24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: AppColors.black,
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
            Align(
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getButtonIcon() {
    return icon != null
        ? Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              icon!,
              width: AppIconSizes.icon_size_20,
              height: AppIconSizes.icon_size_20,
            ),
          )
        : SizedBox();
  }
}
