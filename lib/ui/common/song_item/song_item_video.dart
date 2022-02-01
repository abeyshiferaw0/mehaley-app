import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/share_buttons_bloc/share_buttons_bloc.dart';
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

class SongItemVideo extends StatelessWidget {
  const SongItemVideo(
      {Key? key,
      required this.videoSong,
      required this.onTap,
      required this.onOpenAudioOnly})
      : super(key: key);

  final Song videoSong;
  final VoidCallback onTap;
  final VoidCallback onOpenAudioOnly;

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onTap,
      child: Container(
        height: AppValues.songVideoItemHeight,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding_16,
        ),
        child: Row(
          children: [
            buildExpandedImage(),
            buildExpandedDetails(context),
          ],
        ),
      ),
    );
  }

  Expanded buildExpandedDetails(context) {
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
                        L10nUtil.translateLocale(
                          videoSong.songName,
                          context,
                        ),
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
                        PagesUtilFunctions.getArtistsNames(
                          videoSong.artistsName,
                          context,
                        ),
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
                  onSelected: (AppVideoItemAction appVideoItemAction) {
                    if (appVideoItemAction == AppVideoItemAction.OPEN_AUDIO) {
                      onOpenAudioOnly();
                    }
                    if (appVideoItemAction == AppVideoItemAction.SHARE) {
                      BlocProvider.of<ShareButtonsBloc>(context).add(
                        ShareSongEvent(song: videoSong),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<AppVideoItemAction>>[
                    buildMenuItem(
                      AppVideoItemAction.SHARE,
                      AppLocale.of().share,
                    ),
                    buildMenuItem(
                      AppVideoItemAction.OPEN_AUDIO,
                      AppLocale.of().openAudio,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            AppBouncingButton(
              onTap: onOpenAudioOnly,
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
                    AppLocale.of().openAudio.toUpperCase(),
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
        radius: 4.0,
        child: CachedNetworkImage(
          imageUrl: videoSong.albumArt.imageMediumPath,
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
