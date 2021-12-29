import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/app_icon_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';

import 'featured_album_playlist_header_widget.dart';

class HomePageVideoCarousel extends StatefulWidget {
  const HomePageVideoCarousel({Key? key}) : super(key: key);

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
      if (currentPage < 10) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
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
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return buildVideoItem();
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
  }

  Padding buildVideoItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppMargin.margin_16),
      child: AppCard(
        radius: 6.0,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
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
              Container(
                color: AppColors.completelyBlack.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    FlutterRemix.play_circle_fill,
                    size: AppIconSizes.icon_size_52,
                    color: AppColors.white,
                  ),
                ),
              ),
              Align(
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
                              "Amen Mezmur",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppFontSizes.font_size_12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Tabitha James",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: AppFontSizes.font_size_10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppBouncingButton(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.padding_16,
                            vertical: AppPadding.padding_8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: AppColors.white,
                          ),
                          child: Text(
                            'Play Audio'.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.darkOrange,
                              fontSize: AppFontSizes.font_size_8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: AppIconWidget(),
              ),
            ],
          ),
          imageUrl:
              "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/hagia-sophia-royalty-free-image-1574795258.jpg",
          placeholder: (context, url) => buildImagePlaceHolder(),
          errorWidget: (context, url, e) => buildImagePlaceHolder(),
        ),
      ),
    );
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
            title: AppLocale.of().featuringTxt,
            subTitle: "Videos",
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
                    "Sell all".toUpperCase(),
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
        itemCount: 10,
        size: AppIconSizes.icon_size_10,
        selectedSize: AppIconSizes.icon_size_10,
        selectedDotColor: AppColors.darkOrange,
        dotColor: AppColors.lightGrey,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
