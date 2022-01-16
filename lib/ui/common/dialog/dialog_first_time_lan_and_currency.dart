import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/app_start_bloc/app_start_bloc.dart';
import 'package:mehaley/business_logic/cubits/currency_cubit.dart';
import 'package:mehaley/business_logic/cubits/localization_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/data_providers/settings_data_provider.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/enums/setting_enums/app_currency.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogFirstTimeLanAndCurrency extends StatefulWidget {
  final VoidCallback onLanguageChange;

  const DialogFirstTimeLanAndCurrency(
      {Key? key, required this.onLanguageChange})
      : super(key: key);

  @override
  State<DialogFirstTimeLanAndCurrency> createState() =>
      _DialogFirstTimeLanAndCurrencyState();
}

class _DialogFirstTimeLanAndCurrencyState
    extends State<DialogFirstTimeLanAndCurrency> {
  @override
  void initState() {
    ///SET USER FIRST TIME TO FALSE
    BlocProvider.of<AppStartBloc>(context).add(
      SetAppFirstLaunchEvent(isFirstTime: false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Material(
            child: Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.8,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_20,
                vertical: AppPadding.padding_16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  ///BUILD DIALOG HEADER
                  buildHeader(),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Divider(
                    color: AppColors.lightGrey,
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),

                  ///LANGUAGE PICKER SECTION
                  buildLanguagePicker(context),

                  ///CURRENCY REMOVE PICKER
                  ///CURRENCY PICKER SECTION
                  buildCurrencyPicker(context),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  AppBouncingButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.padding_8),
                      child: Text(
                        AppLocale.of().done.toUpperCase(),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBouncingButton buildPickerItem({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_20,
          vertical: AppPadding.padding_12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.white : AppColors.lightGrey,
            width: 1,
          ),
          color: isSelected ? AppColors.orange : AppColors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
            isSelected
                ? Icon(
                    FlutterRemix.checkbox_circle_fill,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_20,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildLanguagePicker(context) {
    return BlocBuilder<LocalizationCubit, AppLanguage>(
      builder: (context, appLanguage) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().chooseYourLanguge.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            buildPickerItem(
              context: context,
              text: 'አማርኛ',
              isSelected: isLocaleSelected(AppLanguage.AMHARIC),
              onTap: () {
                BlocProvider.of<LocalizationCubit>(context).changeLocale(
                  appLanguage: AppLanguage.AMHARIC,
                );
                widget.onLanguageChange();
              },
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            buildPickerItem(
              context: context,
              text: 'English',
              isSelected: isLocaleSelected(AppLanguage.ENGLISH),
              onTap: () {
                BlocProvider.of<LocalizationCubit>(context).changeLocale(
                  appLanguage: AppLanguage.ENGLISH,
                );
                widget.onLanguageChange();
              },
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            buildPickerItem(
              context: context,
              text: 'Oromiffa',
              isSelected: isLocaleSelected(AppLanguage.OROMIFA),
              onTap: () {
                BlocProvider.of<LocalizationCubit>(context).changeLocale(
                  appLanguage: AppLanguage.OROMIFA,
                );
                widget.onLanguageChange();
              },
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            buildPickerItem(
              context: context,
              text: 'Tigregna',
              isSelected: isLocaleSelected(AppLanguage.TIGRINYA),
              onTap: () {
                BlocProvider.of<LocalizationCubit>(context).changeLocale(
                  appLanguage: AppLanguage.TIGRINYA,
                );
                widget.onLanguageChange();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildCurrencyPicker(context) {
    return BlocBuilder<CurrencyCubit, AppCurrency>(
      builder: (context, appCurrency) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: AppMargin.margin_24,
            ),
            Text(
              AppLocale.of().chooseYourPreferredCurrency.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_8.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            Row(
              children: [
                Expanded(
                  child: buildPickerItem(
                    context: context,
                    text: 'ETB',
                    isSelected: isCurrencySelected(AppCurrency.ETB),
                    onTap: () {
                      BlocProvider.of<CurrencyCubit>(context)
                          .changePreferredCurrency(
                        mAppCurrency: AppCurrency.ETB,
                      );
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                Expanded(
                  child: buildPickerItem(
                    context: context,
                    text: 'USD',
                    isSelected: isCurrencySelected(AppCurrency.USD),
                    onTap: () {
                      BlocProvider.of<CurrencyCubit>(context)
                          .changePreferredCurrency(
                        mAppCurrency: AppCurrency.USD,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.icAppIconOnly,
            width: AppValues.appSplashIconSize * 0.2,
          ),
          SizedBox(
            width: AppMargin.margin_16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.of().welcomeToMehaley,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_8,
                ),
                Text(
                  AppLocale.of().firstTimeDialogMsg,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.txtGrey,
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  isLocaleSelected(AppLanguage appLanguage) {
    AppLanguage currentAppLanguage = L10nUtil.getCurrentLocale();
    return currentAppLanguage == appLanguage;
  }

  isCurrencySelected(AppCurrency appCurrency) {
    AppCurrency currentAppCurrency =
        SettingsDataProvider().getPreferredCurrency();
    return currentAppCurrency == appCurrency;
  }
}
