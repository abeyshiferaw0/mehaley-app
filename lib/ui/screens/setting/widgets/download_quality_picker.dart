import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/settings_page_bloc/settings_page_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/settings_page_data.dart';
import 'package:mehaley/data/models/enums/setting_enums/download_song_quality.dart';
import 'package:sizer/sizer.dart';

class DownloadQualityPicker extends StatelessWidget {
  const DownloadQualityPicker({
    Key? key,
    required this.settingsPageData,
  }) : super(key: key);

  final SettingsPageData settingsPageData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.of().preferredDownlaodQuality,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_8,
              ),
              Text(
                AppLocale.of().preferredDownlaodQualityMsg,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.txtGrey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        DropdownButton(
          value: settingsPageData.downloadSongQuality,
          dropdownColor: AppColors.lightGrey,
          focusColor: AppColors.orange,
          icon: Padding(
            padding: const EdgeInsets.only(
              left: AppPadding.padding_8,
            ),
            child: Icon(
              PhosphorIcons.caret_down_fill,
              size: AppIconSizes.icon_size_16,
              color: AppColors.txtGrey,
            ),
          ),
          style: TextStyle(
            color: AppColors.txtGrey,
            fontSize: AppFontSizes.font_size_12.sp,
            fontWeight: FontWeight.w400,
          ),
          onChanged: (DownloadSongQuality? value) {},
          items: [
            buildDropdownMenuItem(
              context: context,
              appDownloadQualityOptions: DownloadSongQuality.LOW_QUALITY,
              isActive: settingsPageData.downloadSongQuality ==
                  DownloadSongQuality.LOW_QUALITY,
            ),
            buildDropdownMenuItem(
              context: context,
              appDownloadQualityOptions: DownloadSongQuality.MEDIUM_QUALITY,
              isActive: settingsPageData.downloadSongQuality ==
                  DownloadSongQuality.MEDIUM_QUALITY,
            ),
            buildDropdownMenuItem(
              context: context,
              appDownloadQualityOptions: DownloadSongQuality.HIGH_QUALITY,
              isActive: settingsPageData.downloadSongQuality ==
                  DownloadSongQuality.HIGH_QUALITY,
            ),
          ],
        ),
      ],
    );
  }

  DropdownMenuItem<DownloadSongQuality> buildDropdownMenuItem(
      {required DownloadSongQuality appDownloadQualityOptions,
      required bool isActive,
      required BuildContext context}) {
    return DropdownMenuItem<DownloadSongQuality>(
      onTap: () {
        BlocProvider.of<SettingsPageBloc>(context).add(
          ChangeSongDownloadQualityEvent(
            downloadSongQuality: appDownloadQualityOptions,
          ),
        );
      },
      value: appDownloadQualityOptions,
      child: Text(
        EnumToString.convertToString(appDownloadQualityOptions)
            .replaceAll('_', ' '),
        style: TextStyle(
          color: isActive ? AppColors.darkOrange : AppColors.txtGrey,
          fontSize: AppFontSizes.font_size_10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
