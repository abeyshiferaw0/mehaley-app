import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/lyric_item.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/screens/player/lyric_full_page.dart';
import 'package:mehaley/ui/screens/player/widgets/share_btn_widget.dart';
import 'package:mehaley/ui/screens/player/widgets/shimmer_lyric.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

class LyricPlayerWidget extends StatefulWidget {
  const LyricPlayerWidget({required this.song});

  final Song song;

  @override
  _LyricPlayerWidgetState createState() => _LyricPlayerWidgetState();
}

class _LyricPlayerWidgetState extends State<LyricPlayerWidget> {
  //SCROLLER CONTROLLER AND LISTENER
  final ItemScrollController lyricScrollController = ItemScrollController();
  final ItemPositionsListener lyricPositionsListener =
      ItemPositionsListener.create();

  _LyricPlayerWidgetState();

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColor;

  //CURRENT LYRIC ITEM
  LyricItem? currentLyricItem;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      BlocProvider.of<LyricBloc>(context).add(
        LoadSongLyricEvent(
          songId: widget.song.songId,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is PlayerPageDominantColorChangedState) {
          dominantColor = ColorUtil.changeColorSaturation(state.color, 0.9);
        }
        return BlocBuilder<LyricBloc, LyricState>(
          builder: (context, state) {
            if (state is LyricDataLoaded) {
              if (state.lyricList.length > 0 &&
                  state.songId == widget.song.songId) {
                return buildLyricLoaded(context, state);
              } else {
                return SizedBox();
              }
            }
            if (state is LyricDataLoadingError) {
              return buildLyricLoadingError();
            }
            if (state is LyricDataLoading) {
              return ShimmerLyric(
                dominantColor: dominantColor,
              );
            }
            return SizedBox();
          },
        );
      },
    );
  }

  GestureDetector buildLyricLoaded(
      BuildContext context, LyricDataLoaded lyricData) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PagesUtilFunctions.createBottomToUpAnimatedRoute(
              page: BlocProvider.value(
                value: BlocProvider.of<LyricBloc>(context),
                child: LyricFullPage(
                  song: widget.song,
                  dominantColor: dominantColor,
                ),
              ),
            ),
          );
        },
        child: BlocListener<SongPositionCubit, CurrentPlayingPosition>(
            listener: (context, duration) {
              //LISTEN TO LYRIC AND DURATION CHANGES
              try {
                if (lyricData.lyricList.length > 0) {
                  LyricItem lyricItem =
                      lyricData.lyricList.firstWhere((element) {
                    if (element.startTimeMillisecond >
                        duration.currentDuration.inMilliseconds) {
                      return true;
                    }
                    return false;
                  });
                  if (currentLyricItem != lyricItem) {
                    setState(() {
                      currentLyricItem = lyricItem;
                    });
                  }
                  lyricScrollController.scrollTo(
                    index: lyricItem.index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              } catch (e) {}
              //LISTEN TO LYRIC AND DURATION CHANGES
            },
            child: Container(
              height: AppValues.lyricPlayerHeight,
              padding: EdgeInsets.all(AppPadding.padding_14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocale.of().lyrics.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_10.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: AppMargin.margin_8),
                  Divider(
                    color: AppColors.lightGrey,
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lyricData.lyricList.length,
                      itemBuilder: (context, index) {
                        return Text(
                          getLyricItemText(lyricData.lyricList, index),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_16.sp,
                            color: currentLyricItem != null
                                ? (currentLyricItem!.index == index
                                    ? ColorUtil.changeColorSaturation(
                                        dominantColor,
                                        0.8,
                                      )
                                    : AppColors.black)
                                : AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                      itemScrollController: lyricScrollController,
                      itemPositionsListener: lyricPositionsListener,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ShareBtnWidget(),
                  )
                ],
              ),
            )));
  }

  Container buildLyricLoadingError() {
    return Container(
      height: AppValues.lyricPlayerHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(AppPadding.padding_14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().lyrics.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          Divider(
            color: AppColors.lightGrey,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocale.of().cantLoadLyrics,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.font_size_12.sp,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Text(
                    AppLocale.of().checkYourInternetConnection.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.darkGrey,
                      fontSize: AppFontSizes.font_size_10.sp,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  AppBouncingButton(
                    onTap: () {
                      BlocProvider.of<LyricBloc>(context).add(
                        LoadSongLyricEvent(
                          songId: widget.song.songId,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_32,
                        vertical: AppPadding.padding_8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: Text(
                        AppLocale.of().tryAgain.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontSizes.font_size_10.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getLyricItemText(List<LyricItem> lyricList, int index) {
    if (lyricList.isNotEmpty) {
      if (index < lyricList.length) {
        return lyricList[index].content;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }
}
