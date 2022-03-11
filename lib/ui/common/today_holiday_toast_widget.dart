import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/app_monthly_holidays_list.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/monthly_holiday.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/date_util/etDateTime.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';

class TodayHolidayToastWidget extends StatefulWidget {
  const TodayHolidayToastWidget({Key? key}) : super(key: key);

  @override
  State<TodayHolidayToastWidget> createState() =>
      _TodayHolidayToastWidgetState();
}

class _TodayHolidayToastWidgetState extends State<TodayHolidayToastWidget> {
  late MonthlyHoliday monthlyHoliday;
  late EtDatetime now;

  @override
  void initState() {
    now = new EtDatetime.now();
    int day = now.date['day']!;
    monthlyHoliday = AppMonthlyHolidaysList.list.elementAt(day - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLanguage appLanguage = L10nUtil.getCurrentLocale();

    return AppCard(
      radius: 12,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.getTodayHolidayGradient(),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.padding_16,
          horizontal: AppPadding.padding_16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppAssets.icAppWordIconWhite,
                  height: AppIconSizes.icon_size_12,
                  fit: BoxFit.contain,
                ),
                Text(
                  appLanguage == AppLanguage.AMHARIC
                      ? "የዛሬ ወርሃዊ በዓላት"
                      : "Today's holidays",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorMapper.getWhite(),
                  ),
                ),
                AppBouncingButton(
                  onTap: () {
                    OverlaySupportEntry.of(context)!.dismiss();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.padding_4),
                    child: Container(
                      child: Icon(
                        FlutterRemix.close_line,
                        color: ColorMapper.getWhite(),
                        size: AppIconSizes.icon_size_24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            Text(
              appLanguage == AppLanguage.AMHARIC
                  ? monthlyHoliday.holidayNameAm
                  : monthlyHoliday.holidayNameEn,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.bold,
                color: ColorMapper.getWhite(),
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            Text(
              "${now.monthGeez} ${now.day}, ${now.year}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w600,
                color: ColorMapper.getWhite(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
