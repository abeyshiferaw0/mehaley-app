import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/common/menu/artist_menu_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class ArtistPageHeader extends StatefulWidget {
  const ArtistPageHeader({
    required this.shrinkPercentage,
    required this.artistPageData,
  });

  final double shrinkPercentage;
  final ArtistPageData artistPageData;

  @override
  _ArtistPageHeaderState createState() =>
      _ArtistPageHeaderState(artistPageData);
}

class _ArtistPageHeaderState extends State<ArtistPageHeader> {
  //CONTROLLER FOR PAGE VIEW
  PageController controller = PageController(
    initialPage: 0,
  );
  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  final ArtistPageData artistPageData;

  _ArtistPageHeaderState(this.artistPageData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppValues.artistSliverHeaderHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: ColorUtil.darken(AppColors.white, 0.1),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          CachedNetworkImage(
            fit: BoxFit.cover,
            height: AppValues.artistSliverHeaderHeight,
            width: double.infinity,
            imageUrl: artistPageData.artist.artistImages[0].imageLargePath,
            placeholder: (context, url) => buildImagePlaceHolder(),
            errorWidget: (context, url, e) => buildImagePlaceHolder(),
          ),
          Container(
            width: double.infinity,
            height: AppValues.artistSliverHeaderHeight,
            decoration: BoxDecoration(
              gradient: AppGradients.getArtistHeaderCovorGradient(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 1 - widget.shrinkPercentage,
              child: buildArtistInfo(artistPageData),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: buildAppBar(widget.shrinkPercentage, artistPageData),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(double shrinkPercentage, ArtistPageData artistPageData) {
    return AppBar(
      backgroundColor: AppColors.white.withOpacity(shrinkPercentage),
      shadowColor: AppColors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          FlutterRemix.arrow_left_line,
          size: AppIconSizes.icon_size_24,
          color: ColorUtil.darken(AppColors.white, shrinkPercentage),
        ),
      ),
      title: Opacity(
        opacity: shrinkPercentage,
        child: Text(
          L10nUtil.translateLocale(artistPageData.artist.artistName, context),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_16,
            fontWeight: FontWeight.w600,
            color: ColorUtil.darken(AppColors.white, shrinkPercentage),
          ),
        ),
      ),
      actions: [
        AppBouncingButton(
          child: Padding(
            padding: const EdgeInsets.all(
              AppPadding.padding_8,
            ),
            child: Icon(
              FlutterRemix.more_2_fill,
              size: AppIconSizes.icon_size_24,
              color: ColorUtil.darken(AppColors.white, shrinkPercentage),
            ),
          ),
          onTap: () {
            PagesUtilFunctions.showMenuSheet(
              context: context,
              child: ArtistMenuWidget(
                artist: artistPageData.artist,
                noOfAlbum: artistPageData.noOfAlbum,
                noOfSong: artistPageData.noOfSong,
              ),
            );
          },
        )
      ],
    );
  }

  Widget buildArtistInfo(ArtistPageData artistPageData) {
    return Wrap(
      children: [
        Transform.translate(
          //scale: (1 - widget.shrinkPercentage),
          //angle: (1 - widget.shrinkPercentage),
          offset: Offset(0, (widget.shrinkPercentage) * -50),
          child: Container(
            height: AppValues.artistSliverHeaderHeight,
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  L10nUtil.translateLocale(
                    artistPageData.artist.artistName,
                    context,
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: AppFontSizes.font_size_28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppMargin.margin_16),
                Text(
                  L10nUtil.translateLocale(
                    artistPageData.artist.artistAboutBiography,
                    context,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppMargin.margin_20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${artistPageData.noOfAlbum} ${AppLocale.of().albums}',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: AppMargin.margin_4),
                      child: Icon(
                        Icons.circle,
                        color: AppColors.white,
                        size: AppIconSizes.icon_size_4,
                      ),
                    ),
                    Text(
                      AppLocale.of().noOfSongs(
                          noOfSong: artistPageData.noOfSong.toString()),
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSizes.font_size_10.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppMargin.margin_48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
}
