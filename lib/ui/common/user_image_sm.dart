import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              color:
                  hasBorder ? AppColors.darkGrey : AuthUtil.getUserColor(state),
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
          imageUrl: appUser.socialProfileImgUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.lightGrey,
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.lightGrey,
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
}
