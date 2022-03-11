import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:sizer/sizer.dart';

class UserPlaylistAddMezmursBtn extends StatelessWidget {
  const UserPlaylistAddMezmursBtn({Key? key, required this.makeSolid})
      : super(key: key);

  final bool makeSolid;

  @override
  Widget build(BuildContext context) {
    return makeSolid ? buildSolidButton(context) : buildNonSolidButton();
  }

  Widget buildNonSolidButton() {
    return SizedBox();
    // return AppBouncingButton(
    //   onTap: () {},
    //   child: Container(
    //     padding: EdgeInsets.symmetric(
    //       horizontal: AppPadding.padding_20,
    //       vertical: AppPadding.padding_6,
    //     ),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(20),
    //       border: Border.all(
    //         color: ColorMapper.getWhite().withOpacity(0.3),
    //         width: 1,
    //       ),
    //     ),
    //     child: Text(
    //      AppLocale.of().addSongs.toUpperCase(),
    //       style: TextStyle(
    //         fontSize: AppFontSizes.font_size_8.sp,
    //         color: ColorMapper.getWhite(),
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //   ),
    // );
  }

  Container buildSolidButton(context) {
    return Container(
      height: 150,
      child: AppBouncingButton(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocale.of().addSongsToPlaylist,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: ColorMapper.getDarkGrey(),
                fontWeight: FontWeight.w400,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: AppPadding.padding_32,
            //     vertical: AppPadding.padding_8,
            //   ),
            //   decoration: BoxDecoration(
            //     color: ColorMapper.getWhite(),
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   child: Text(
            //     AppLocale.of().addSongs.toUpperCase(),
            //     style: TextStyle(
            //       fontSize: AppFontSizes.font_size_12.sp,
            //       color: ColorMapper.getBlack(),
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
