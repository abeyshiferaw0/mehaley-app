import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/ui/common/user_image_sm.dart';
import 'package:mehaley/util/auth_util.dart';

class UserProfilePic extends StatelessWidget {
  const UserProfilePic({Key? key, required this.size, required this.fontSize})
      : super(key: key);

  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserWidgetsCubit, AppUser>(
      builder: (context, state) {
        return Container(
          child: getUserProfilePic(state, size, fontSize, context),
        );
      },
    );
  }

  static Widget getUserProfilePic(
      AppUser appUser, double size, double fontSize, context) {
    if (appUser.profileImageId != null) {
      return UserImageSm(
        size: size,
        appUser: appUser,
        appUserImageType: AppUserImageType.PROFILE_IMAGE,
        borderColor: Colors.black,
        hasBorder: false,
        fontSize: fontSize,
        letter: AuthUtil.getUserName(
            BlocProvider.of<AppUserWidgetsCubit>(context).state)[0],
      );
    } else if (appUser.socialProfileImgUrl != null) {
      return UserImageSm(
        size: size,
        appUser: appUser,
        appUserImageType: AppUserImageType.SOCIAL_IMAGE,
        borderColor: Colors.black,
        hasBorder: false,
        fontSize: fontSize,
        letter: AuthUtil.getUserName(
            BlocProvider.of<AppUserWidgetsCubit>(context).state)[0],
      );
    } else {
      return UserImageSm(
        size: size,
        appUser: appUser,
        appUserImageType: AppUserImageType.NONE,
        borderColor: Colors.black,
        hasBorder: false,
        fontSize: fontSize,
        letter: AuthUtil.getUserName(
            BlocProvider.of<AppUserWidgetsCubit>(context).state)[0],
      );
    }
  }
}
