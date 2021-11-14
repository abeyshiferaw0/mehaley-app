import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/user_profile_pic.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';import 'package:elf_play/app_language/app_locale.dart';

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
                  color: AppColors.black.withOpacity(0.3),
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
                      color: AppColors.white,
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
            color: AppColors.lightGrey,
            size: AppIconSizes.icon_size_24,
          ),
        ],
      ),
    );
  }
}
