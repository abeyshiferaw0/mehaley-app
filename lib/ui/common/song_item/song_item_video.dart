import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:sizer/sizer.dart';

class SongItemVideo extends StatelessWidget {
  const SongItemVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.songVideoItemHeight,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
      ),
      child: Row(
        children: [
          buildExpandedImage(),
          buildExpandedDetails(),
        ],
      ),
    );
  }

  Expanded buildExpandedDetails() {
    return Expanded(
      flex: 60,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppPadding.padding_16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Song name of song name",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: AppMargin.margin_4,
                      ),
                      Text(
                        "Artist singer name",
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          color: AppColors.txtGrey,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<AppVideoItemAction>(
                  child: Icon(
                    Icons.more_vert,
                    size: AppIconSizes.icon_size_24,
                    color: AppColors.black,
                  ),
                  onSelected: (AppVideoItemAction appVideoItemAction) {},
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<AppVideoItemAction>>[
                    buildMenuItem(
                      AppVideoItemAction.SHARE,
                      AppLocale.of().share,
                    ),
                    buildMenuItem(
                      AppVideoItemAction.OPEN_AUDIO,
                      "Open Audio",
                    ),
                    buildMenuItem(
                      AppVideoItemAction.OPEN_WITH_YOUTUBE,
                      "Open With Youtube",
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            AppBouncingButton(
              onTap: () {},
              child: AppCard(
                withShadow: false,
                radius: 100.0,
                child: Container(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.padding_12,
                    vertical: AppPadding.padding_6,
                  ),
                  child: Text(
                    "Open Audio".toUpperCase(),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      color: AppColors.darkOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildExpandedImage() {
    return Expanded(
      flex: 40,
      child: AppCard(
        radius: 0.0,
        child: CachedNetworkImage(
          imageUrl:
              "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg",
          fit: BoxFit.cover,
          placeholder: (context, url) => buildImagePlaceHolder(),
          errorWidget: (context, url, error) => buildImagePlaceHolder(),
          imageBuilder: (context, imageProvider) => Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: AppIconWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildMenuItem(AppVideoItemAction appVideoItemAction, String title) {
    return PopupMenuItem<AppVideoItemAction>(
      value: appVideoItemAction,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: AppFontSizes.font_size_10.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
