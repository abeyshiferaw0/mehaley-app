import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'package:mehaley/business_logic/blocs/payment_blocs/preferred_payment_method_bloc/preferred_payment_method_bloc.dart';
import 'package:mehaley/business_logic/blocs/settings_page_bloc/settings_page_bloc.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/settings_page_data.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/app_subscribe_card.dart';
import 'package:mehaley/ui/common/app_subscription_active_card.dart';
import 'package:mehaley/ui/common/dialog/payment/dialog_prefred_payment_method.dart';
import 'package:mehaley/ui/screens/setting/widgets/download_quality_picker.dart';
import 'package:mehaley/ui/screens/setting/widgets/drop_down_options_picker.dart';
import 'package:mehaley/ui/screens/setting/widgets/elf_info_widget.dart';
import 'package:mehaley/ui/screens/setting/widgets/logout_button.dart';
import 'package:mehaley/ui/screens/setting/widgets/prefred_currency_picker.dart';
import 'package:mehaley/ui/screens/setting/widgets/profile_button.dart';
import 'package:mehaley/ui/screens/setting/widgets/setting_large_button.dart';
import 'package:mehaley/ui/screens/setting/widgets/setting_radio_item.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    BlocProvider.of<SettingsPageBloc>(context).add(
      LoadSettingsDataEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OneSignalBloc, OneSignalState>(
          listener: (context, state) {
            ///ONE SIGNAL SENDING TAGS SUCCESSFUL RELOAD PAGE
            if (state is OneSignalTagAdded) {
              BlocProvider.of<SettingsPageBloc>(context).add(
                LoadSettingsDataEvent(),
              );
            }

            ///ONE SIGNAL SENDING TAGS ERROR
            if (state is OneSignalTagAddingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: false,
                  msg: AppLocale.of().couldntConnectMsg,
                  txtColor: AppColors.white,
                ),
              );
            }
          },
        ),
        BlocListener<PreferredPaymentMethodBloc, PreferredPaymentMethodState>(
          listener: (context, state) {
            if (state is PreferredPaymentMethodChangedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildAppSnackBar(
                  bgColor: AppColors.black.withOpacity(0.9),
                  isFloating: true,
                  msg: AppLocale.of().preferredPaymentChangedTo(
                    paymentName: PagesUtilFunctions.getPaymentMethodName(
                      state.appPaymentMethod,
                      context,
                    ),
                  ),
                  txtColor: AppColors.white,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
        appBar: AppBar(
          //brightness: Brightness.dark,
          systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
          backgroundColor: AppColors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: AppColors.black,
            icon: Icon(
              FlutterRemix.arrow_left_line,
              size: AppIconSizes.icon_size_24,
            ),
          ),
          title: Text(
            AppLocale.of().settings,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<SettingsPageBloc, SettingsPageState>(
          builder: (context, state) {
            if (state is SettingPageLoadingState) {
              return AppLoading(size: AppValues.loadingWidgetSize);
            } else if (state is SettingPageLoadedState) {
              return buildSingleSettingsPageLoaded(state.settingsPageData);
            } else if (state is SettingPageLoadingErrorState) {
              return SizedBox(
                child: Center(
                  child: Text(
                    state.error,
                    style: TextStyle(
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Stack buildSingleSettingsPageLoaded(SettingsPageData settingsPageData) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ///SUBSCRIBE CARD
              AppSubscribeCard(
                topMargin: 0.0,
                bottomMargin: AppMargin.margin_24,
              ),

              ///ACTIVE SUBSCRIPTION CARD
              AppSubscriptionActiveCard(
                topMargin: 0.0,
                bottomMargin: AppMargin.margin_24,
              ),

              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                  vertical: AppMargin.margin_20,
                ),
                child: Column(
                  children: [
                    ProfileButton(),
                    SettingRadioItem(
                      title: AppLocale.of().dataSaver,
                      subTitle: AppLocale.of().dataSaverMsg,
                      isEnabled: settingsPageData.isDataSaverTurnedOn,
                      onSwitched: (bool value) {
                        BlocProvider.of<SettingsPageBloc>(context).add(
                          ChangeDataSaverStatusEvent(),
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_20),

                    DropDownOptionsPicker(
                      notificationTags: settingsPageData.notificationTags,
                      onLanguageChanged: () {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: AppMargin.margin_20),
                    SettingLargeButton(
                      title: AppLocale.of().preferredPaymentMethod,
                      subTitle: AppLocale.of().chooseYourPreferredMethod,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PreferredPaymentDialog();
                          },
                        );
                      },
                    ),
                    // SettingRadioItem(
                    //   title: AppLocale.of().autoDownload,
                    //   subTitle: AppLocale.of().autoDownloadMsg,
                    //   isEnabled: true,
                    //   onSwitched: (bool value) {},
                    // ),
                    SizedBox(height: AppMargin.margin_32),
                    DownloadQualityPicker(settingsPageData: settingsPageData),
                    SizedBox(height: AppMargin.margin_32),

                    ///DOLLAR BIRR CHOOSER REMOVED
                    PreferredCurrencyPicker(settingsPageData: settingsPageData),
                    SizedBox(height: AppMargin.margin_32),
                    SettingLargeButton(
                      title: AppLocale.of().rateApp,
                      subTitle: AppLocale.of().rateAppMsg,
                      onTap: () {
                        PagesUtilFunctions.rateApp();
                      },
                    ),
                    SizedBox(height: AppMargin.margin_32),
                    SettingLargeButton(
                      title: AppLocale.of().shareApp,
                      subTitle: AppLocale.of().shareAppMsg,
                      onTap: () {
                        PagesUtilFunctions.shareApp();
                      },
                    ),
                    SizedBox(height: AppMargin.margin_32),

                    SizedBox(
                      height: AppMargin.margin_48,
                    ),
                    ElfInfoWidget(),
                    LogoutButton()
                  ],
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<OneSignalBloc, OneSignalState>(
          buildWhen: (preState, state) {
            if (state is OneSignalTagAdding) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is OneSignalTagAdding) {
              return Container(
                color: AppColors.black.withOpacity(0.4),
                child: AppLoading(size: AppValues.loadingWidgetSize / 2),
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }
}
