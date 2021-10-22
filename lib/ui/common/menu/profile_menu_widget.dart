import 'package:elf_play/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/app_user.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/util/auth_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../app_gradients.dart';
import '../player_items_placeholder.dart';
import '../user_profile_pic.dart';
import 'menu_items/menu_item.dart';

class ProfileMenuWidget extends StatelessWidget {
  ProfileMenuWidget({
    Key? key,
    required this.onUpdateSuccess,
  }) : super(key: key);

  final Function(AppUser appUser) onUpdateSuccess;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil(context: context).getScreenHeight(),
      decoration: BoxDecoration(
        gradient: AppGradients().getMenuGradient(),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: AppBouncingButton(
                  child: Icon(
                    PhosphorIcons.caret_circle_down_light,
                    color: AppColors.lightGrey,
                    size: AppIconSizes.icon_size_32,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil(context: context).getScreenHeight() * 0.4,
              ),
              buildMenuHeader(context),
              SizedBox(
                height: AppMargin.margin_32,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                ),
                child: Column(
                  children: [
                    MenuItem(
                      isDisabled: false,
                      hasTopMargin: false,
                      iconColor: AppColors.grey.withOpacity(0.6),
                      icon: PhosphorIcons.pencil_simple_light,
                      title: AppLocalizations.of(context)!.editProfile,
                      onTap: () {
                        Navigator.pop(context);
                        PagesUtilFunctions.openEditProfilePage(
                          context,
                          (AppUser appUser) {
                            onUpdateSuccess(appUser);
                          },
                        );
                      },
                    ),
                    MenuItem(
                      isDisabled: false,
                      hasTopMargin: true,
                      iconColor: AppColors.grey.withOpacity(0.6),
                      icon: PhosphorIcons.share_network_light,
                      title: AppLocalizations.of(context)!.share,
                      onTap: () {},
                    ),
                    SizedBox(height: AppMargin.margin_20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMenuHeader(context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserProfilePic(
            fontSize: AppFontSizes.font_size_12.sp,
            size: AppValues.menuHeaderImageSize,
          ),
          SizedBox(height: AppMargin.margin_16),
          BlocBuilder<AppUserWidgetsCubit, AppUser>(
            builder: (context, state) {
              return Text(
                AuthUtil.getUserName(state),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          SizedBox(height: AppMargin.margin_8),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
