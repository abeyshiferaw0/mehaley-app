import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import 'language_setting_item.dart';
import 'notification_setting_item.dart';

class DropDownOptionsPicker extends StatefulWidget {
  const DropDownOptionsPicker({Key? key}) : super(key: key);

  @override
  _DropDownOptionsPickerState createState() => _DropDownOptionsPickerState();
}

class _DropDownOptionsPickerState extends State<DropDownOptionsPicker> {
  bool languageIsExpanded = false;
  bool notificationIsExpanded = false;
  AppLanguageOptions appLanguageOptions = AppLanguageOptions.AMHARIC;

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
          //hasIcon: false,
          backgroundColor: AppColors.black,
          headerBuilder: (context, isExpanded) {
            return Container(
              margin: EdgeInsets.only(top: AppMargin.margin_28),
              child: Row(
                children: [
                  Text(
                    "Choose Your Language",
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
            );
          },
          body: Container(
            child: Theme(
              data: ThemeData(unselectedWidgetColor: AppColors.txtGrey),
              child: Column(
                children: [
                  LanguageSettingItem(
                    text: "ኣማርኟ",
                    isSelected: isLocaleSelected(L10nUtil.amharic),
                    locale: L10nUtil.amharic,
                  ),
                  LanguageSettingItem(
                    text: "English",
                    isSelected: isLocaleSelected(L10nUtil.english),
                    locale: L10nUtil.english,
                  ),
                  LanguageSettingItem(
                    text: "Oromiffa",
                    isSelected: false,
                    locale: L10nUtil.amharic,
                  ),
                  LanguageSettingItem(
                    text: "Tigrinya",
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
          //hasIcon: false,
          backgroundColor: AppColors.black,
          headerBuilder: (context, isExpanded) {
            return Container(
              margin: EdgeInsets.only(top: AppMargin.margin_28),
              child: Row(
                children: [
                  Text(
                    "Receive Notifications",
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
            );
          },
          body: Container(
            child: Theme(
              data: ThemeData(unselectedWidgetColor: AppColors.txtGrey),
              child: Column(
                children: [
                  NotificationSettingItem(
                    isEnabled: true,
                    text: 'Push notifications',
                    onSwitched: (bool isEnabled) {},
                  ),
                  NotificationSettingItem(
                    isEnabled: false,
                    text: 'New Releases',
                    onSwitched: (bool isEnabled) {},
                  ),
                  NotificationSettingItem(
                    isEnabled: false,
                    text: 'Recommendations',
                    onSwitched: (bool isEnabled) {},
                  ),
                  NotificationSettingItem(
                    isEnabled: false,
                    text: 'Daily Affirmations',
                    onSwitched: (bool isEnabled) {},
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
}
