import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/api_response/artist_page_data.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/menu/artist_menu_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import '../../../common/like_follow/artist_follow_button.dart';

class ArtistPageHeader extends StatefulWidget {
  const ArtistPageHeader({
    required this.shrinkPercentage,
    required this.artistPageData,
  });

  final double shrinkPercentage;
  final ArtistPageData artistPageData;

  @override
  _ArtistPageHeaderState createState() => _ArtistPageHeaderState(artistPageData);
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
    return Stack(
      children: [
        CachedNetworkImage(
          fit: BoxFit.cover,
          height: 360,
          width: double.infinity,
          imageUrl: AppApi.baseUrl + artistPageData.artist.artistImages[0].imageMediumPath,
          placeholder: (context, url) => buildImagePlaceHolder(),
          errorWidget: (context, url, e) => buildImagePlaceHolder(),
        ),
        Container(
          height: 360,
          decoration: BoxDecoration(
            gradient: AppGradients().getArtistHeaderGradient(),
          ),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                buildAppBar(widget.shrinkPercentage, artistPageData),
                Opacity(
                  opacity: 1 - widget.shrinkPercentage,
                  child: buildArtistInfo(artistPageData),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container buildAppBar(double shrinkPercentage, ArtistPageData artistPageData) {
    return Container(
      height: 90,
      width: double.infinity,
      color: AppColors.black.withOpacity(shrinkPercentage),
      padding: EdgeInsets.only(top: AppPadding.padding_28),
      margin: EdgeInsets.only(bottom: AppMargin.margin_12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                PhosphorIcons.caret_left_light,
                size: AppIconSizes.icon_size_28,
                color: AppColors.lightGrey,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: shrinkPercentage,
              child: Text(
                L10nUtil.translateLocale(artistPageData.artist.artistName, context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ArtistFollowButton(
                  isFollowing: artistPageData.artist.isFollowed!,
                  artistId: artistPageData.artist.artistId,
                  askDialog: false,
                ),
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                AppBouncingButton(
                  child: Icon(
                    PhosphorIcons.dots_three_vertical_bold,
                    size: AppIconSizes.icon_size_28,
                    color: AppColors.lightGrey,
                  ),
                  onTap: () {
                    PagesUtilFunctions.showMenuDialog(
                      context: context,
                      child: ArtistMenuWidget(
                        title: L10nUtil.translateLocale(artistPageData.artist.artistName, context),
                        imageUrl: AppApi.baseUrl + artistPageData.artist.artistImages[0].imageMediumPath,
                        noOfAlbum: artistPageData.noOfAlbum,
                        noOfSong: artistPageData.noOfSong,
                        isFollowing: artistPageData.artist.isFollowed!,
                        artistId: artistPageData.artist.artistId,
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildArtistInfo(ArtistPageData artistPageData) {
    return Transform.translate(
      //scale: (1 - widget.shrinkPercentage),
      //angle: (1 - widget.shrinkPercentage),
      offset: Offset(0, (widget.shrinkPercentage) * 50),
      child: Container(
        height: 260,
        padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified,
                  size: AppIconSizes.icon_size_24,
                  color: AppColors.blue,
                ),
                SizedBox(width: AppMargin.margin_4),
                Text(
                  AppLocalizations.of(context)!.verifiedArtist.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: AppFontSizes.font_size_12.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppMargin.margin_4),
            Text(
              L10nUtil.translateLocale(
                artistPageData.artist.artistName,
                context,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.lightGrey,
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
                color: AppColors.lightGrey,
                fontSize: AppFontSizes.font_size_10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: AppMargin.margin_20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${artistPageData.noOfAlbum} ${AppLocalizations.of(context)!.albums}',
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
                  AppLocalizations.of(context)!.noOfSongs(artistPageData.noOfSong),
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
      ),
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ARTIST);
}
