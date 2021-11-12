import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/app_permission.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.enablePermissions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_16,
                ),
                Text(
                  AppLocalizations.of(context)!.enablePermissionsMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.txtGrey,
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
                          color: AppColors.black,
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
                            color: AppColors.black,
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
                      color: AppColors.green,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .goToSystemSettings
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
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
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
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
