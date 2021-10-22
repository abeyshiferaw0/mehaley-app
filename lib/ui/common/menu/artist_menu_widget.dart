import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/menu/menu_items/artist_follow_menu_item.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';
import '../player_items_placeholder.dart';
import 'menu_items/menu_item.dart';

class ArtistMenuWidget extends StatelessWidget {
  ArtistMenuWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.noOfAlbum,
    required this.noOfSong,
    required this.isFollowing,
    required this.artistId,
  }) : super(key: key);

  final bool isFollowing;
  final int artistId;
  final String title;
  final String imageUrl;
  final int noOfAlbum;
  final int noOfSong;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil(context: context).getScreenHeight(),
      decoration: BoxDecoration(
        gradient: AppGradients().getMenuGradient(),
      ),
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: AppMargin.margin_48,
                ),
                child: AppBouncingButton(
                  child: Icon(
                    PhosphorIcons.caret_circle_down_light,
                    color: AppColors.lightGrey,
                    size: AppIconSizes.icon_size_32,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil(context: context).getScreenHeight() * 0.2,
              ),
              buildMenuHeader(context),
              SizedBox(
                height: AppMargin.margin_32,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppMargin.margin_16,
                ),
                child: Column(
                  children: [
                    ArtistFollowMenuItem(
                        isFollowing: isFollowing, artistId: artistId),
                    MenuItem(
                      isDisabled: false,
                      hasTopMargin: true,
                      iconColor: AppColors.grey.withOpacity(0.6),
                      icon: PhosphorIcons.share_network_light,
                      title: AppLocalizations.of(context)!.shareArtist,
                      onTap: () {},
                    ),
                    SizedBox(height: AppMargin.margin_20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMenuHeader(context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              height: AppValues.menuHeaderImageSize,
              width: AppValues.menuHeaderImageSize,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => buildImagePlaceHolder(),
              errorWidget: (context, url, error) => buildImagePlaceHolder(),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppMargin.margin_2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.noOfAlbum(noOfSong),
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppMargin.margin_4),
                child: Icon(
                  Icons.circle,
                  color: AppColors.lightGrey,
                  size: AppIconSizes.icon_size_4,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.noOfSongs(noOfSong),
                style: TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: AppFontSizes.font_size_10.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
