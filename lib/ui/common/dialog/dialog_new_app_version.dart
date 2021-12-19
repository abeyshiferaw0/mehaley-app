import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/app_start_bloc/app_start_bloc.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogNewAppVersion extends StatefulWidget {
  final VoidCallback onUpdateClicked;

  const DialogNewAppVersion({
    Key? key,
    required this.onUpdateClicked,
  }) : super(key: key);

  @override
  State<DialogNewAppVersion> createState() => _DialogNewAppVersionState();
}

class _DialogNewAppVersionState extends State<DialogNewAppVersion> {
  @override
  void initState() {
    BlocProvider.of<AppStartBloc>(context).add(
      SetNotificationPermissionShownDateEvent(date: DateTime.now()),
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
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: AppColors.pagesBgColor,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: AppMargin.margin_16,
                        ),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                AppAssets.icAppFullIcon,
                                width: AppIconSizes.icon_size_64,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: CircleAvatar(
                                  radius:
                                      AppValues.lyricPageCloseButtonSize * 0.8,
                                  backgroundColor: AppColors.completelyBlack
                                      .withOpacity(0.2),
                                  child: Icon(
                                    FlutterRemix.close_line,
                                    size: AppValues.lyricPageCloseButtonSize *
                                        0.8,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Lottie.asset(
                          AppAssets.updateLottie,
                          height: AppIconSizes.icon_size_64 * 3,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.padding_20,
                      vertical: AppPadding.padding_32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.of().newVersionAvailable,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.padding_16,
                          ),
                          child: Text(
                            AppLocale.of().newVersionAvailableMsg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.txtGrey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppMargin.margin_32,
                        ),
                        AppBouncingButton(
                          onTap: () {
                            widget.onUpdateClicked();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.padding_20,
                              vertical: AppPadding.padding_8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.orange,
                            ),
                            child: Text(
                              AppLocale.of().updateApp.toUpperCase(),
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppMargin.margin_32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppBouncingButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocale.of().maybeLatter,
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            AppBouncingButton(
                              onTap: () async {
                                await AppHiveBoxes.instance.systemUpdate.put(
                                    AppValues.newVersionDontAskAgainKey, true);
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocale.of().dontAskAgain,
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
