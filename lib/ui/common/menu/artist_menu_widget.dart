import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/menu/menu_items/artist_follow_menu_item.dart';
import 'package:sizer/sizer.dart';

import '../app_card.dart';
import '../player_items_placeholder.dart';
import 'menu_items/menu_item.dart';

class ArtistMenuWidget extends StatelessWidget {
  ArtistMenuWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    this.noOfAlbum,
    this.noOfSong,
    required this.isFollowing,
    required this.artistId,
  }) : super(key: key);

  final bool isFollowing;
  final int artistId;
  final String title;
  final String imageUrl;
  final int? noOfAlbum;
  final int? noOfSong;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppValues.menuBottomSheetRadius),
          topRight: Radius.circular(AppValues.menuBottomSheetRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: AppMargin.margin_16,
              ),
              buildMenuHeader(context),
              SizedBox(
                height: AppMargin.margin_8,
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
                      icon: FlutterRemix.share_line,
                      title: AppLocale.of().shareArtist,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: AppMargin.margin_16),
          AppCard(
            withShadow: false,
            radius: 100,
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
          SizedBox(width: AppMargin.margin_16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSizes.font_size_12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppMargin.margin_4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  noOfAlbum != null
                      ? Text(
                          AppLocale.of().noOfAlbum(
                            noOfAlbums: noOfAlbum.toString(),
                          ),
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: AppFontSizes.font_size_10.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      : SizedBox(),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: AppMargin.margin_4),
                    child: Icon(
                      Icons.circle,
                      color: AppColors.darkGrey,
                      size: AppIconSizes.icon_size_4,
                    ),
                  ),
                  noOfSong != null
                      ? Text(
                          AppLocale.of().noOfSongs(
                            noOfSong: noOfSong.toString(),
                          ),
                          style: TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: AppFontSizes.font_size_10.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      : SizedBox(),
                ],
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
