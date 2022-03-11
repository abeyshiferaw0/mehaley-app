import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/app_permission.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogPermissionPermanentlyRefused extends StatelessWidget {
  final VoidCallback onGoToSetting;
  final List<AppPermission> permissionList;

  const DialogPermissionPermanentlyRefused({
    Key? key,
    required this.onGoToSetting,
    required this.permissionList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Container(
            width: ScreenUtil(context: context).getScreenWidth() * 0.8,
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_20,
              vertical: AppPadding.padding_32,
            ),
            decoration: BoxDecoration(
              color: ColorMapper.getWhite(),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  AppLocale.of().enablePermissions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorMapper.getBlack(),
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_16,
                ),
                Text(
                  AppLocale.of().enablePermissionsMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorMapper.getTxtGrey(),
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_32,
                ),
                ListView.separated(
                  itemCount: permissionList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          permissionList.elementAt(index).icon,
                          color: ColorMapper.getBlack(),
                          size: AppIconSizes.icon_size_24,
                        ),
                        SizedBox(
                          width: AppMargin.margin_8,
                        ),
                        Text(
                          permissionList.elementAt(index).permissionMsg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_12.sp,
                            fontWeight: FontWeight.w400,
                            color: ColorMapper.getBlack(),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: AppMargin.margin_16,
                    );
                  },
                ),
                SizedBox(
                  height: AppMargin.margin_32,
                ),
                AppBouncingButton(
                  onTap: () {
                    onGoToSetting();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding_20,
                      vertical: AppPadding.padding_4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorMapper.getOrange(),
                    ),
                    child: Text(
                      AppLocale.of().goToSystemSettings.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorMapper.getWhite(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_20,
                ),
                AppBouncingButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocale.of().cancel,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorMapper.getBlack(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
