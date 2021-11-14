import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';import 'package:elf_play/app_language/app_locale.dart';

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
                  from:
                      AppLocale.of().playingFromFeaturedMezmurs,
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
                  from:
                      AppLocale.of().playingFromFeaturedMezmurs,
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
        selectedDotColor: AppColors.darkGreen,
        dotColor: ColorUtil.lighten(AppColors.darkGrey, 0.2),
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
          color: Colors.white,
          fontSize: AppFontSizes.font_size_14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
