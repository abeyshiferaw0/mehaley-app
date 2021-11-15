import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/user_profile_pic.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:sizer/sizer.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        Navigator.pushNamed(context, AppRouterPaths.profileRoute);
      },
      shrinkRatio: 6,
      child: Row(
        children: [
          Container(
            height: AppIconSizes.icon_size_64,
            width: AppIconSizes.icon_size_64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppIconSizes.icon_size_64 / 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white.withOpacity(0.3),
                  spreadRadius: 6,
                  blurRadius: 6,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: UserProfilePic(
              fontSize: AppFontSizes.font_size_12.sp,
              size: AppValues.userPlaylistImageSize,
            ),
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AppUserWidgetsCubit, AppUser>(
                builder: (context, state) {
                  return Text(
                    AuthUtil.getUserName(state),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  );
                },
              ),
              // SizedBox(
              //   height: AppMargin.margin_2,
              // ),
              Text(
                AppLocale.of().viewProfile,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.txtGrey,
                ),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Icon(
            PhosphorIcons.caret_right_light,
            color: AppColors.darkGrey,
            size: AppIconSizes.icon_size_24,
          ),
        ],
      ),
    );
  }
}
