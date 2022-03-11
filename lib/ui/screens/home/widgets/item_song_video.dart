import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ItemSongVideo extends StatelessWidget {
  const ItemSongVideo({Key? key, required this.songVideo}) : super(key: key);

  final Song songVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppMargin.margin_16),
      child: AppBouncingButton(
        onTap: () {
          PagesUtilFunctions.openYtPlayerPage(
            context,
            songVideo,
            false,
          );
        },
        child: AppCard(
          radius: 4.0,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Stack(
              children: [
                buildBgImageContainer(imageProvider),
                buildOpacityContainer(),
                buildSongVideoInfo(context),
                buildOpenAudioButton(),
              ],
            ),
            imageUrl: songVideo.albumArt.imageLargePath,
            placeholder: (context, url) => buildImagePlaceHolder(),
            errorWidget: (context, url, e) => buildImagePlaceHolder(),
          ),
        ),
      ),
    );
  }

  Align buildOpenAudioButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: AppIconWidget(),
    );
  }

  Align buildSongVideoInfo(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.all(AppPadding.padding_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10nUtil.translateLocale(
                      songVideo.songName,
                      context,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorMapper.getWhite(),
                      fontSize: AppFontSizes.font_size_12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    PagesUtilFunctions.getArtistsNames(
                      songVideo.artistsName,
                      context,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorMapper.getLightGrey(),
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            AppBouncingButton(
              onTap: () {
                PagesUtilFunctions.openVideoAudioOnly(
                  context,
                  songVideo,
                  false,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding_16,
                  vertical: AppPadding.padding_8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: ColorMapper.getWhite(),
                ),
                child: Text(
                  'Play Audio'.toUpperCase(),
                  style: TextStyle(
                    color: ColorMapper.getDarkOrange(),
                    fontSize: AppFontSizes.font_size_8.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildOpacityContainer() {
    return Container(
      color: ColorMapper.getCompletelyBlack().withOpacity(0.3),
      child: Center(
        child: Icon(
          FlutterRemix.play_circle_fill,
          size: AppIconSizes.icon_size_52,
          color: ColorMapper.getWhite(),
        ),
      ),
    );
  }

  Container buildBgImageContainer(ImageProvider<Object> imageProvider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
