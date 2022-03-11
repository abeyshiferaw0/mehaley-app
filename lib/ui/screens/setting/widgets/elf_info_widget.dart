import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ElfInfoWidget extends StatelessWidget {
  const ElfInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppMargin.margin_20),
      child: Column(
        children: [
          Text(
            AppLocale.of().appName,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              fontWeight: FontWeight.w400,
              color: ColorMapper.getBlack(),
            ),
          ),
          SizedBox(
            height: AppMargin.margin_4,
          ),
          FutureBuilder(
            future: PagesUtilFunctions.getAppVersionNumber(),
            initialData: 'loading',
            builder: (context, snapShot) {
              if (snapShot.data != null) {
                if (snapShot.data is String) {
                  return Text(
                    AppLocale.of().appVersion(
                      versionCode: snapShot.data as String,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorMapper.getTxtGrey(),
                    ),
                  );
                }
              }
              return SizedBox();
            },
          ),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          // Text(
          //   AppLocale.of().appTermsAndCondition,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: AppFontSizes.font_size_8.sp,
          //     fontWeight: FontWeight.w400,
          //     color: ColorMapper.getTxtGrey(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
