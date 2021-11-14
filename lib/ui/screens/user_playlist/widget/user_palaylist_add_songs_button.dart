import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';import 'package:elf_play/app_language/app_locale.dart';

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
    //         color: AppColors.white.withOpacity(0.3),
    //         width: 1,
    //       ),
    //     ),
    //     child: Text(
    //      AppLocale.of().addSongs.toUpperCase(),
    //       style: TextStyle(
    //         fontSize: AppFontSizes.font_size_8.sp,
    //         color: AppColors.white,
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
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: AppPadding.padding_32,
            //     vertical: AppPadding.padding_8,
            //   ),
            //   decoration: BoxDecoration(
            //     color: AppColors.white,
            //     borderRadius: BorderRadius.circular(30),
            //   ),
            //   child: Text(
            //     AppLocale.of().addSongs.toUpperCase(),
            //     style: TextStyle(
            //       fontSize: AppFontSizes.font_size_12.sp,
            //       color: AppColors.black,
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
