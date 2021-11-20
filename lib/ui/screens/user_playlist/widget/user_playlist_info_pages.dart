import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/user_profile_pic.dart';
import 'package:mehaley/ui/screens/playlist/widget/icon_text.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class UserPlaylistInfoPageOne extends StatelessWidget {
  UserPlaylistInfoPageOne({required this.myPlaylist});

  final TextStyle followersTextStyle = TextStyle(
    fontSize: AppFontSizes.font_size_12,
    color: AppColors.darkGrey,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Container(
                color: AppColors.txtGrey,
                width: AppValues.playlistPageOneImageSize,
                height: AppValues.playlistPageOneImageSize,
                child: PagesUtilFunctions.getSongGridImage(
                  myPlaylist,
                ),
              ),
            ),
            SizedBox(height: AppMargin.margin_16),
            //PLAYLIST TITLE
            Text(
              L10nUtil.translateLocale(myPlaylist.playlistNameText, context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppMargin.margin_4),
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
          buildUserPlaylistNameAndDescription(context),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildUserPlaylistOwnerProfilePic(context),
                  SizedBox(
                    width: AppMargin.margin_12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.of().playlistBy,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          color: AppColors.darkGrey,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: AppMargin.margin_4,
                      ),
                      Text(
                        PagesUtilFunctions.getUserPlaylistOwner(
                          myPlaylist,
                          context,
                        ),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSizes.font_size_12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          buildUserPlaylistDateAndTime(),
          SizedBox(height: AppMargin.margin_20),
        ],
      ),
    );
  }

  Column buildUserPlaylistNameAndDescription(context) {
    return Column(
      children: [
        Text(
          L10nUtil.translateLocale(
            myPlaylist.playlistNameText,
            context,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppMargin.margin_8),
        Text(
          PagesUtilFunctions.getUserPlaylistDescription(myPlaylist, context),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
            color: AppColors.white.withOpacity(0.2),
          ),
        ],
      ),
      child: UserProfilePic(
        fontSize: AppFontSizes.font_size_12.sp,
        size: AppValues.userPlaylistImageSize,
      ),
    );
  }

  Row buildUserPlaylistDateAndTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconText(
          icon: FlutterRemix.calendar_line,
          text: PagesUtilFunctions.getUserPlaylistDateCreated(
            myPlaylist,
          ),
        ),
        IconText(
          icon: FlutterRemix.time_line,
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
