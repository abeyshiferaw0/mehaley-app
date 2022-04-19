import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/home_page_tabs_change_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class ViewMoreButton extends StatelessWidget {
  const ViewMoreButton({Key? key, required this.groupType}) : super(key: key);

  final GroupType groupType;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: () {
        ///GO TO HOME PAGE TAB BASED ON GROUP TYPE
        BlocProvider.of<HomePageTabsChangeCubit>(context)
            .changeGroupType(groupType);
      },
      child: Container(
        padding: EdgeInsets.all(AppPadding.padding_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocale.of().viewMore.toUpperCase(),
              style: TextStyle(
                  fontSize: AppFontSizes.font_size_10.sp,
                  color: ColorMapper.getDarkOrange(),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: AppMargin.margin_2,
            ),
            Icon(
              FlutterRemix.arrow_right_s_line,
              size: AppIconSizes.icon_size_16,
              color: ColorMapper.getDarkOrange(),
            )
          ],
        ),
      ),
    );
  }
}
