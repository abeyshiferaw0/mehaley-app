import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/enums/user_login_type.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/auth_util.dart';

class UserImageSm extends StatelessWidget {
  const UserImageSm({
    Key? key,
    required this.size,
    required this.appUserImageType,
    required this.appUser,
    required this.borderColor,
    required this.hasBorder,
    required this.fontSize,
    required this.letter,
  }) : super(key: key);

  final double size;
  final AppUser appUser;
  final Color borderColor;
  final bool hasBorder;
  final double fontSize;
  final String letter;
  final AppUserImageType appUserImageType;

  @override
  Widget build(BuildContext context) {
    if (appUserImageType == AppUserImageType.SOCIAL_IMAGE) {
      return buildSocialNetWorkImage(borderColor);
    } else if (appUserImageType == AppUserImageType.PROFILE_IMAGE) {
      return buildProfileImage(borderColor);
    } else {
      return BlocBuilder<AppUserWidgetsCubit, AppUser>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              border:
                  hasBorder ? Border.all(color: borderColor, width: 1) : null,
              color: hasBorder
                  ? AppColors.lightGrey
                  : AuthUtil.getUserColor(state),
            ),
            width: size,
            height: size,
            child: Center(
              child: Text(
                appUser.userName != null
                    ? appUser.userName!.isNotEmpty
                        ? appUser.userName!.substring(0, 1)
                        : letter
                    : letter,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Container buildSocialNetWorkImage(Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        border: hasBorder ? Border.all(color: color, width: 1) : null,
      ),
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          height: size,
          width: size,
          imageUrl:
              '${appUser.socialProfileImgUrl!}${getSocialImageSize(appUser)}',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.darkGrey,
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.darkGrey,
          ),
        ),
      ),
    );
  }

  Container buildProfileImage(Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        border: hasBorder ? Border.all(color: color, width: 1) : null,
      ),
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          height: size,
          width: size,
          imageUrl: AppApi.baseUrl + appUser.profileImageId!.imageMediumPath,
          fit: BoxFit.cover,
          placeholder: (context, url) => buildItemsImagePlaceHolder(),
          errorWidget: (context, url, error) => buildItemsImagePlaceHolder(),
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
  }

  String getSocialImageSize(AppUser appUser) {
    if (appUser.loginType == UserLoginType.GOOGLE) {
      return '?sz=120';
    } else if (appUser.loginType == UserLoginType.FACEBOOK) {
      return '?width=120';
    } else {
      return '';
    }
  }
}
