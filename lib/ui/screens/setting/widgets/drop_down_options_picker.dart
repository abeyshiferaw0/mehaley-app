import 'package:elf_play/business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import 'language_setting_item.dart';
import 'notification_setting_item.dart';

class DropDownOptionsPicker extends StatefulWidget {
  const DropDownOptionsPicker({
    Key? key,
    required this.notificationTags,
  }) : super(key: key);

  final Map<String, dynamic> notificationTags;

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
      dividerColor: AppColors.black,
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
          backgroundColor: AppColors.black,
          headerBuilder: (context, isExpanded) {
            return Column(
              children: [
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.chooseYourLanguge,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      isExpanded
                          ? PhosphorIcons.caret_up_light
                          : PhosphorIcons.caret_down_light,
                      size: AppIconSizes.icon_size_24,
                      color: AppColors.white,
                    )
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
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
                    isSelected: isLocaleSelected(L10nUtil.amharic),
                    locale: L10nUtil.amharic,
                  ),
                  LanguageSettingItem(
                    text: 'English',
                    isSelected: isLocaleSelected(L10nUtil.english),
                    locale: L10nUtil.english,
                  ),
                  LanguageSettingItem(
                    text: 'Oromiffa',
                    isSelected: false,
                    locale: L10nUtil.english,
                  ),
                  LanguageSettingItem(
                    text: 'Tigrinya',
                    isSelected: false,
                    locale: L10nUtil.amharic,
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
          backgroundColor: AppColors.black,
          headerBuilder: (context, isExpanded) {
            return Column(
              children: [
                SizedBox(height: AppMargin.margin_16),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.reciveNotifications,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Icon(
                      isExpanded
                          ? PhosphorIcons.caret_up_light
                          : PhosphorIcons.caret_down_light,
                      size: AppIconSizes.icon_size_24,
                      color: AppColors.white,
                    )
                  ],
                ),
                SizedBox(height: AppMargin.margin_16),
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
                    text: AppLocalizations.of(context)!.pushNotifications,
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
                    text: AppLocalizations.of(context)!.newReleases,
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
                    text: AppLocalizations.of(context)!.latestUpdates,
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
                    text: AppLocalizations.of(context)!.dailyCerlabrations,
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

  isLocaleSelected(Locale locale) {
    Locale cLocale = Localizations.localeOf(context);
    return cLocale.languageCode == locale.languageCode;
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
