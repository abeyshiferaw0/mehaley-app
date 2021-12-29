import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'package:mehaley/business_logic/cubits/localization_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';

import 'language_setting_item.dart';
import 'notification_setting_item.dart';

class DropDownOptionsPicker extends StatefulWidget {
  const DropDownOptionsPicker({
    Key? key,
    required this.notificationTags,
    this.onLanguageChanged,
  }) : super(key: key);

  final Map<String, dynamic> notificationTags;
  final VoidCallback? onLanguageChanged;

  @override
  _DropDownOptionsPickerState createState() => _DropDownOptionsPickerState(
        notificationTags: notificationTags,
      );
}

class _DropDownOptionsPickerState extends State<DropDownOptionsPicker> {
  bool languageIsExpanded = false;
  bool notificationIsExpanded = false;
  final Map<String, dynamic> notificationTags;

  _DropDownOptionsPickerState({required this.notificationTags});

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 300),
      dividerColor: AppColors.pagesBgColor,
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      expansionCallback: (int item, bool status) {
        setState(() {
          if (item == 0) {
            languageIsExpanded = !languageIsExpanded;
          } else if (item == 1) {
            notificationIsExpanded = !notificationIsExpanded;
          }
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          hasIcon: false,
          backgroundColor: AppColors.pagesBgColor,
          headerBuilder: (context, isExpanded) {
            return Column(
              children: [
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    Text(
                      AppLocale.of().chooseYourLanguge,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      isExpanded
                          ? FlutterRemix.arrow_up_s_line
                          : FlutterRemix.arrow_down_s_line,
                      size: AppIconSizes.icon_size_24,
                      color: AppColors.black,
                    )
                  ],
                ),
              ],
            );
          },
          body: Container(
            child: Theme(
              data: ThemeData(unselectedWidgetColor: AppColors.txtGrey),
              child: Column(
                children: [
                  LanguageSettingItem(
                    text: 'ኣማርኟ',
                    isSelected: isLocaleSelected(AppLanguage.AMHARIC),
                    onTap: () {
                      BlocProvider.of<LocalizationCubit>(context).changeLocale(
                        appLanguage: AppLanguage.AMHARIC,
                      );
                      if (widget.onLanguageChanged != null) {
                        widget.onLanguageChanged!();
                      }
                    },
                  ),
                  LanguageSettingItem(
                    text: 'English',
                    isSelected: isLocaleSelected(AppLanguage.ENGLISH),
                    onTap: () {
                      BlocProvider.of<LocalizationCubit>(context).changeLocale(
                        appLanguage: AppLanguage.ENGLISH,
                      );
                      if (widget.onLanguageChanged != null) {
                        widget.onLanguageChanged!();
                      }
                    },
                  ),
                  LanguageSettingItem(
                    text: 'Oromiffa',
                    isSelected: isLocaleSelected(AppLanguage.OROMIFA),
                    onTap: () {
                      BlocProvider.of<LocalizationCubit>(context).changeLocale(
                        appLanguage: AppLanguage.OROMIFA,
                      );
                      if (widget.onLanguageChanged != null) {
                        widget.onLanguageChanged!();
                      }
                    },
                  ),
                  LanguageSettingItem(
                    text: 'Tigregna',
                    isSelected: isLocaleSelected(AppLanguage.TIGRINYA),
                    onTap: () {
                      BlocProvider.of<LocalizationCubit>(context).changeLocale(
                        appLanguage: AppLanguage.TIGRINYA,
                      );
                      if (widget.onLanguageChanged != null) {
                        widget.onLanguageChanged!();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          isExpanded: languageIsExpanded,
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          hasIcon: false,
          backgroundColor: AppColors.pagesBgColor,
          headerBuilder: (context, isExpanded) {
            return Column(
              children: [
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    Text(
                      AppLocale.of().reciveNotifications,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      isExpanded
                          ? FlutterRemix.arrow_up_s_line
                          : FlutterRemix.arrow_down_s_line,
                      size: AppIconSizes.icon_size_24,
                      color: AppColors.black,
                    )
                  ],
                ),
              ],
            );
          },
          body: Container(
            child: Theme(
              data: ThemeData(unselectedWidgetColor: AppColors.txtGrey),
              child: Column(
                children: [
                  NotificationSettingItem(
                    isEnabled: isNotificationEnabled(
                      AppUserNotificationTypes.RECEIVE_ADMIN_NOTIFICATIONS,
                      notificationTags,
                    ),
                    text: AppLocale.of().pushNotifications,
                    onSwitched: () {
                      ///CHANGE TAG
                      BlocProvider.of<OneSignalBloc>(context).add(
                        SetNotificationTagEvent(
                          notificationTags: notificationTags,
                          appUserNotificationTypes: AppUserNotificationTypes
                              .RECEIVE_ADMIN_NOTIFICATIONS,
                        ),
                      );
                    },
                  ),
                  NotificationSettingItem(
                    isEnabled: isNotificationEnabled(
                      AppUserNotificationTypes
                          .RECEIVE_NEW_RELEASES_NOTIFICATIONS,
                      notificationTags,
                    ),
                    text: AppLocale.of().newReleases,
                    onSwitched: () {
                      ///CHANGE TAG
                      BlocProvider.of<OneSignalBloc>(context).add(
                        SetNotificationTagEvent(
                          notificationTags: notificationTags,
                          appUserNotificationTypes: AppUserNotificationTypes
                              .RECEIVE_NEW_RELEASES_NOTIFICATIONS,
                        ),
                      );
                    },
                  ),
                  NotificationSettingItem(
                    isEnabled: isNotificationEnabled(
                      AppUserNotificationTypes
                          .RECEIVE_LATEST_UPDATES_NOTIFICATIONS,
                      notificationTags,
                    ),
                    text: AppLocale.of().latestUpdates,
                    onSwitched: () {
                      ///CHANGE TAG
                      BlocProvider.of<OneSignalBloc>(context).add(
                        SetNotificationTagEvent(
                          notificationTags: notificationTags,
                          appUserNotificationTypes: AppUserNotificationTypes
                              .RECEIVE_LATEST_UPDATES_NOTIFICATIONS,
                        ),
                      );
                    },
                  ),
                  NotificationSettingItem(
                    isEnabled: isNotificationEnabled(
                      AppUserNotificationTypes
                          .RECEIVE_DAILY_CEREMONIES_NOTIFICATIONS,
                      notificationTags,
                    ),
                    text: AppLocale.of().dailyCerlabrations,
                    onSwitched: () {
                      ///CHANGE TAG
                      BlocProvider.of<OneSignalBloc>(context).add(
                        SetNotificationTagEvent(
                          notificationTags: notificationTags,
                          appUserNotificationTypes: AppUserNotificationTypes
                              .RECEIVE_DAILY_CEREMONIES_NOTIFICATIONS,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          isExpanded: notificationIsExpanded,
        )
      ],
    );
  }

  isLocaleSelected(AppLanguage appLanguage) {
    AppLanguage currentAppLanguage = L10nUtil.getCurrentLocale();
    return currentAppLanguage == appLanguage;
  }

  bool isNotificationEnabled(
    AppUserNotificationTypes appUserNotificationTypes,
    Map<String, dynamic> notificationTags,
  ) {
    if (notificationTags.containsKey(
      EnumToString.convertToString(appUserNotificationTypes),
    )) {
      String val = notificationTags[
          EnumToString.convertToString(appUserNotificationTypes)];
      if (int.parse(val) == 1) {
        return true;
      }
      return false;
    }
    return false;
  }
}
