import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';

import 'item_featured_songs.dart';

class HomeFeaturedSongs extends StatefulWidget {
  const HomeFeaturedSongs({Key? key, required this.featuredSongs})
      : super(key: key);

  final List<Song> featuredSongs;

  @override
  _HomeFeaturedSongsState createState() => _HomeFeaturedSongsState();
}

class _HomeFeaturedSongsState extends State<HomeFeaturedSongs> {
  late final _currentPageNotifier;
  late PageController _pageController;

  @override
  void initState() {
    _currentPageNotifier = ValueNotifier<int>(0);
    _pageController = PageController(viewportFraction: 0.92);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(),
          SizedBox(
            height: AppMargin.margin_12,
          ),
          buildIndicators(),
          SizedBox(
            height: AppMargin.margin_16,
          ),
          buildFeaturedItemsPager()
        ],
      ),
    );
  }

  Container buildFeaturedItemsPager() {
    return Container(
      height: AppValues.featuredSongsPagerHeight,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.featuredSongs.length,
        onPageChanged: (index) {
          _currentPageNotifier.value = index;
        },
        itemBuilder: (context, index) {
          return FeaturedSongsItem(
            song: widget.featuredSongs[index],
            onTap: () {
              PagesUtilFunctions.groupItemOnClick(
                groupType: GroupType.SONG,
                items: widget.featuredSongs,
                item: widget.featuredSongs[index],
                playingFrom: PlayingFrom(
                  from: AppLocale.of().playingFromFeaturedMezmurs,
                  title: L10nUtil.translateLocale(
                      widget.featuredSongs[index].songName, context),
                  songSyncPlayedFrom: SongSyncPlayedFrom.RECENTLY_PLAYED,
                  songSyncPlayedFromId: -1,
                ),
                context: context,
                index: index,
              );
            },
            onSmallPlayButtonTap: () {
              PagesUtilFunctions.groupItemOnClick(
                openPlayerPage: false,
                groupType: GroupType.SONG,
                items: widget.featuredSongs,
                item: widget.featuredSongs[index],
                playingFrom: PlayingFrom(
                  from: AppLocale.of().playingFromFeaturedMezmurs,
                  title: L10nUtil.translateLocale(
                      widget.featuredSongs[index].songName, context),
                  songSyncPlayedFrom: SongSyncPlayedFrom.RECENTLY_PLAYED,
                  songSyncPlayedFromId: -1,
                ),
                context: context,
                index: index,
              );
            },
          );
        },
      ),
    );
  }

  Padding buildIndicators() {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: CirclePageIndicator(
        itemCount: widget.featuredSongs.length,
        size: AppIconSizes.icon_size_10,
        selectedSize: AppIconSizes.icon_size_10,
        selectedDotColor: AppColors.darkOrange,
        dotColor: AppColors.lightGrey,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: Text(
        AppLocale.of().featuredMezmurs,
        style: TextStyle(
          color: AppColors.black,
          fontSize: AppFontSizes.font_size_14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
