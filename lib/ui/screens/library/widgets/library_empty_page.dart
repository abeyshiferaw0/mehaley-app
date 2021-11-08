import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            color: AppColors.darkGrey.withOpacity(0.8),
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
                color: AppColors.txtGrey,
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
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocalizations.of(context)!.newPlaylist.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppColors.white,
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
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppLocalizations.of(context)!.downAllPurchased.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
