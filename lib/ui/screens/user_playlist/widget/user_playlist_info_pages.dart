import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/common/user_profile_pic.dart';
import 'package:elf_play/ui/screens/playlist/widget/icon_text.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/app_language/app_locale.dart';

class UserPlaylistInfoPageOne extends StatelessWidget {
  UserPlaylistInfoPageOne({required this.myPlaylist});

  final TextStyle followersTextStyle = TextStyle(
    fontSize: AppFontSizes.font_size_12,
    color: AppColors.lightGrey,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  final MyPlaylist myPlaylist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //ALBUM ART
            SizedBox(
              height: AppMargin.margin_8,
            ),
            Container(
              color: AppColors.txtGrey,
              width: AppValues.playlistPageOneImageSize,
              height: AppValues.playlistPageOneImageSize,
              child: PagesUtilFunctions.getSongGridImage(
                myPlaylist,
              ),
            ),
            SizedBox(height: AppMargin.margin_20),
            //PLAYLIST TITLE
            Text(
              L10nUtil.translateLocale(myPlaylist.playlistNameText, context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_16.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppMargin.margin_8),
            Text(
              PagesUtilFunctions.getUserPlaylistByText(
                myPlaylist,
                context,
              ),
              style: followersTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class UserPlaylistInfoPageTwo extends StatelessWidget {
  final MyPlaylist myPlaylist;
  final List<Song> songs;

  UserPlaylistInfoPageTwo({
    Key? key,
    required this.myPlaylist,
    required this.songs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppMargin.margin_32),
          buildUserPlaylistDescription(context),
          SizedBox(height: AppMargin.margin_32),
          Text(
            AppLocale.of().playlistBy.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10,
              color: AppColors.lightGrey,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppMargin.margin_12),
          buildUserPlaylistOwnerProfilePic(context),
          SizedBox(height: AppMargin.margin_16),
          buildProfileOwnerNameTag(context),
          Expanded(child: SizedBox()),
          buildUserPlaylistDateAndTime(),
          SizedBox(height: AppMargin.margin_20),
        ],
      ),
    );
  }

  Text buildUserPlaylistDescription(context) {
    return Text(
      PagesUtilFunctions.getUserPlaylistDescription(
        myPlaylist,
        context,
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_16,
        color: AppColors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Container buildUserPlaylistOwnerProfilePic(context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppValues.userPlaylistImageSize / 2),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 6,
            color: AppColors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: UserProfilePic(
        fontSize: AppFontSizes.font_size_12.sp,
        size: AppValues.userPlaylistImageSize,
      ),
    );
  }

  Container buildProfileOwnerNameTag(context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_32,
        vertical: AppPadding.padding_2,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(AppValues.playlistPageTwoImageSize / 2),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 12,
            color: AppColors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Text(
        PagesUtilFunctions.getUserPlaylistOwner(
          myPlaylist,
          context,
        ),
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppFontSizes.font_size_10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Row buildUserPlaylistDateAndTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconText(
          icon: PhosphorIcons.calendar_blank_light,
          text: PagesUtilFunctions.getUserPlaylistDateCreated(
            myPlaylist,
          ),
        ),
        IconText(
          icon: PhosphorIcons.clock_light,
          text: PagesUtilFunctions.getPlaylistTotalDuration(
            songs,
          ),
        ),
      ],
    );
  }
}

AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
}
