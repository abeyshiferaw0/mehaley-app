import 'package:elf_play/business_logic/blocs/one_signal_bloc/one_signal_bloc.dart';
import 'package:elf_play/business_logic/blocs/settings_page_bloc/settings_page_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/api_response/settings_page_data.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/common/app_subscribe_card.dart';
import 'package:elf_play/ui/common/dialog/complete_payment_dialog.dart';
import 'package:elf_play/ui/screens/setting/widgets/download_quality_picker.dart';
import 'package:elf_play/ui/screens/setting/widgets/drop_down_options_picker.dart';
import 'package:elf_play/ui/screens/setting/widgets/elf_info_widget.dart';
import 'package:elf_play/ui/screens/setting/widgets/logout_button.dart';
import 'package:elf_play/ui/screens/setting/widgets/profile_button.dart';
import 'package:elf_play/ui/screens/setting/widgets/setting_large_button.dart';
import 'package:elf_play/ui/screens/setting/widgets/setting_radio_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
    return BlocListener<OneSignalBloc, OneSignalState>(
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
              bgColor: AppColors.blue,
              isFloating: false,
              msg:
                  "Couldn't connect to the internet, check your internet connection",
              txtColor: AppColors.white,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          //brightness: Brightness.dark,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: AppColors.darkGrey,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              PhosphorIcons.caret_left_light,
              size: AppIconSizes.icon_size_24,
            ),
          ),
          title: Text(
            "Settings",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
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
              AppSubscribeCard(),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                  vertical: AppMargin.margin_20,
                ),
                child: Column(
                  children: [
                    ProfileButton(),
                    SettingRadioItem(
                      title: "Data Saver",
                      subTitle:
                          "Lowers the quality of your mezmurs streams, for lower data usage",
                      isEnabled: true,
                      onSwitched: (bool value) {},
                    ),
                    DropDownOptionsPicker(
                      notificationTags: settingsPageData.notificationTags,
                    ),
                    SettingLargeButton(
                      title: "Preferred Payment method",
                      subTitle:
                          "Choose your preferred payment method for all purchases",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CompletePaymentDialog();
                          },
                        );
                      },
                    ),
                    // SettingRadioItem(
                    //   title: "Auto Download",
                    //   subTitle: "Start Downloading Purchased Mezmurs Automatically",
                    //   isEnabled: true,
                    //   onSwitched: (bool value) {},
                    // ),
                    DownloadQualityPicker(settingsPageData: settingsPageData),
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
