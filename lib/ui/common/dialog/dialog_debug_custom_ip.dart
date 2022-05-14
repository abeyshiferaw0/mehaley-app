import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class DialogCustomIP extends StatelessWidget {
  final VoidCallback onIpSet;
  final TextEditingController controller = TextEditingController();

  DialogCustomIP({
    Key? key,
    required this.onIpSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          Material(
            child: Container(
              width: ScreenUtil(context: context).getScreenWidth() * 0.85,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding_20,
                vertical: AppPadding.padding_32,
              ),
              decoration: BoxDecoration(
                color: ColorMapper.getWhite(),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    'SET CUSTOM IP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorMapper.getBlack(),
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  TextFormField(
                    controller: controller,
                    textAlignVertical: TextAlignVertical.center,
                    autofocus: true,
                    cursorColor: ColorMapper.getDarkOrange(),
                    onChanged: (key) {},
                    validator: (text) {
                      if (text != null) {
                        if (PagesUtilFunctions.isValidIpAddress(text)) {
                          return null;
                        } else {
                          return AppApi.mainUrl != text ? 'invalid ip' : null;
                        }
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(
                      color: ColorMapper.getBlack(),
                      fontSize: AppFontSizes.font_size_14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_8,
                        vertical: AppPadding.padding_16,
                      ),
                      errorStyle: TextStyle(
                        fontSize: AppFontSizes.font_size_10,
                        color: AppColors.errorRed,
                        fontWeight: FontWeight.w400,
                      ),
                      errorText: '',
                      filled: true,
                      fillColor: ColorMapper.getLightGrey(),
                      border: InputBorder.none,
                      focusColor: ColorMapper.getOrange(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      prefix: Container(
                        color: AppColors.darkGrey,
                        child: Text('HTTP://  '),
                      ),
                      hintText: 'ENTER BASE URI // IP',
                      hintStyle: TextStyle(
                        color: ColorMapper.getTxtGrey(),
                        fontSize: AppFontSizes.font_size_14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_32,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppBouncingButton(
                          onTap: () {
                            controller.text = AppApi.mainUrl;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.padding_20,
                              vertical: AppPadding.padding_16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: ColorMapper.getDarkGrey(),
                            ),
                            child: Center(
                              child: Text(
                                'USE DEFAULT',
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorMapper.getWhite(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppPadding.padding_16,
                      ),
                      Expanded(
                        child: AppBouncingButton(
                          onTap: () {
                            if (PagesUtilFunctions.isValidIpAddress(
                                    controller.text) ||
                                AppApi.mainUrl == controller.text) {
                              if (PagesUtilFunctions.isValidIpAddress(
                                  controller.text)) {
                                AppApi.baseUrl = 'http://${controller.text}';
                              } else {
                                AppApi.baseUrl = '${controller.text}';
                              }
                              onIpSet();
                            } else {
                              SnackBar snackBar = SnackBar(
                                content: Text('Not a valid ip'),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height -
                                        100,
                                    right: 20,
                                    left: 20),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.padding_20,
                              vertical: AppPadding.padding_16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: ColorMapper.getDarkOrange(),
                            ),
                            child: Center(
                              child: Text(
                                'SET IP',
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorMapper.getWhite(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
