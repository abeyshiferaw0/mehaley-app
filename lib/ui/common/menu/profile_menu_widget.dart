import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/app_user_widgets_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_user.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/auth_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

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
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppValues.menuBottomSheetRadius),
          topRight: Radius.circular(AppValues.menuBottomSheetRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: AppMargin.margin_32,
            ),
            buildMenuHeader(context),
            SizedBox(
              height: AppMargin.margin_16,
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
                    iconColor: ColorMapper.getGrey().withOpacity(0.6),
                    icon: FlutterRemix.pencil_line,
                    title: AppLocale.of().editProfile,
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
                    iconColor: ColorMapper.getGrey().withOpacity(0.6),
                    icon: FlutterRemix.share_line,
                    title: AppLocale.of().share,
                    onTap: () {
                      PagesUtilFunctions.shareApp();
                    },
                  ),
                  SizedBox(height: AppMargin.margin_20),
                ],
              ),
            ),
          ],
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
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: ColorMapper.getBlack(),
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
