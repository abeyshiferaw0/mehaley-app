import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/screens/home/widgets/item_song_video.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';

import 'featured_album_playlist_header_widget.dart';

class HomePageVideoCarousel extends StatefulWidget {
  const HomePageVideoCarousel({Key? key, required this.songVideos})
      : super(key: key);

  final List<Song> songVideos;

  @override
  _HomePageVideoCarouselState createState() => _HomePageVideoCarouselState();
}

class _HomePageVideoCarouselState extends State<HomePageVideoCarousel> {
  //NOTIFIER FOR DOTED INDICATOR
  late ValueNotifier<int> _currentPageNotifier;
  //CONTROLLER FOR PAGE VIEW
  late PageController _pageController;
  //TIMER FOR CAROUSEL
  late Timer timer;
  //PAGER CURRENT PAGE
  int currentPage = 0;

  @override
  void initState() {
    ///INDICATOR CONTROLLER INIT
    _currentPageNotifier = new ValueNotifier<int>(0);

    ///PAGE VIEW CONTROLLER INIT
    _pageController = PageController(
      initialPage: 0,
    );

    ///CAROUSEL TIMER INIT
    timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (currentPage < widget.songVideos.length) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      if (widget.songVideos.length > 0) {
        _pageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 700),
          curve: Curves.easeIn,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.songVideos.length > 0) {
      return Container(
        height: ScreenUtil(context: context).getScreenHeight() * 0.33,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(),
            SizedBox(
              height: AppMargin.margin_16,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.songVideos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemSongVideo(
                    songVideo: widget.songVideos[index],
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPageNotifier.value = index;
                    currentPage = index;
                  });
                },
              ),
            ),
            buildIndicators()
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        right: AppMargin.margin_12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FeaturedAlbumPlaylistHeaderWidget(
            title: AppLocale.of().featuredVideos,
            subTitle: AppLocale.of().videos,
          ),
          AppBouncingButton(
            onTap: () {
              Navigator.pushNamed(context, AppRouterPaths.allVideosPage);
            },
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.padding_4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocale.of().seeAll.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.darkOrange,
                      fontSize: AppFontSizes.font_size_10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    FlutterRemix.arrow_right_s_line,
                    size: AppIconSizes.icon_size_20,
                    color: AppColors.darkOrange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildIndicators() {
    return Padding(
      padding: EdgeInsets.only(
        top: AppMargin.margin_24,
        left: AppMargin.margin_16,
      ),
      child: CirclePageIndicator(
        itemCount: widget.songVideos.length,
        size: AppIconSizes.icon_size_10,
        selectedSize: AppIconSizes.icon_size_10,
        selectedDotColor: AppColors.darkOrange,
        dotColor: AppColors.lightGrey,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
