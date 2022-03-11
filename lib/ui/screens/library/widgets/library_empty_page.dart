import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class LibraryEmptyPage extends StatelessWidget {
  const LibraryEmptyPage({
    Key? key,
    required this.icon,
    required this.msg,
    this.emptyMyPlaylist,
    this.emptyOffline,
  }) : super(key: key);

  final IconData icon;
  final String msg;
  final bool? emptyMyPlaylist;
  final bool? emptyOffline;

  @override
  Widget build(BuildContext context) {
    return buildEmptyContainer(context);
  }

  Container buildEmptyContainer(context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppIconSizes.icon_size_72,
            color: ColorMapper.getLightGrey().withOpacity(0.8),
          ),
          SizedBox(
            height: AppMargin.margin_8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_32 * 2,
            ),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: ColorMapper.getTxtGrey(),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          buildEmptyMyPlaylist(context),
          //buildOffline(context),
        ],
      ),
    );
  }

  Widget buildEmptyMyPlaylist(context) {
    if (emptyMyPlaylist == null) return SizedBox();
    if (!emptyMyPlaylist!) return SizedBox();
    return Column(
      children: [
        SizedBox(
          height: AppMargin.margin_16,
        ),
        AppBouncingButton(
          onTap: () {
            PagesUtilFunctions.openCreatePlaylistPage(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_32,
              vertical: AppPadding.padding_8,
            ),
            decoration: BoxDecoration(
              color: ColorMapper.getDarkOrange(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocale.of().newPlaylist.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: ColorMapper.getWhite(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOffline(context) {
    if (emptyOffline == null) return SizedBox();
    if (!emptyOffline!) return SizedBox();
    return Column(
      children: [
        SizedBox(
          height: AppMargin.margin_16,
        ),
        AppBouncingButton(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_32,
              vertical: AppPadding.padding_8,
            ),
            decoration: BoxDecoration(
              color: ColorMapper.getDarkOrange(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocale.of().downAllPurchased.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: ColorMapper.getBlack(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
