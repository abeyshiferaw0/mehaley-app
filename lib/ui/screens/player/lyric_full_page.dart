import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:mehaley/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/share_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/lyric_item.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/custom_track_shape.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/screens/player/widgets/share_btn_widget.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:screenshot/screenshot.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

class LyricFullPage extends StatefulWidget {
  const LyricFullPage(
      {Key? key, required this.song, required this.dominantColor})
      : super(key: key);

  final Song song;
  final Color dominantColor;

  @override
  _LyricFullPageState createState() =>
      _LyricFullPageState(dominantColor: dominantColor);
}

class _LyricFullPageState extends State<LyricFullPage> {
  _LyricFullPageState({required this.dominantColor});

  final Color dominantColor;

  //AUDIO PLAYER PLAYBACK STATE CHANGES
  double progress = 0.0;
  double bufferedPosition = 0.0;
  double totalDuration = 0.0;

  //SCROLLER CONTROLLER AND LISTENER
  final ItemScrollController lyricScrollController = ItemScrollController();
  final ItemPositionsListener lyricPositionsListener =
      ItemPositionsListener.create();

  //SCREEN SHOT CONTROLLER
  ScreenshotController _screenshotController = ScreenshotController();

  //CURRENT LYRIC ITEM
  LyricItem? currentLyricItem;

  //SHOW MEHALEY ICON
  bool showAppLogo = false;

  //ANIMATED LYRIC SCREENSHOT BG
  late Color lyricBgColor;
  late double animPadding;

  @override
  void initState() {
    lyricBgColor = ColorUtil.darken(
      ColorUtil.changeColorSaturation(dominantColor, 0.8),
      0.15,
    );
    animPadding = 0;
    super.initState();
  }

  //QUEUE;
  final List<MediaItem> queue = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentPlayingCubit, Song?>(
      listener: (context, state) {
        if (state == null) {
          Navigator.pop(context);
        } else {
          if (state.songId != widget.song.songId) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: lyricBgColor,
        body: AnimatedContainer(
          color: lyricBgColor,
          padding: EdgeInsets.all(animPadding),
          duration: Duration(milliseconds: 100),
          child: SafeArea(
            child: MultiBlocListener(
              listeners: [
                BlocListener<SongPositionCubit, CurrentPlayingPosition>(
                  listener: (context, state) {
                    setState(() {
                      progress = state.currentDuration.inSeconds.toDouble();
                    });
                  },
                ),
                BlocListener<SongBufferedCubit, Duration>(
                  listener: (context, state) {
                    bufferedPosition = state.inSeconds.toDouble();
                  },
                ),
                BlocListener<SongDurationCubit, Duration>(
                  listener: (context, state) {
                    totalDuration = state.inSeconds.toDouble();
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Screenshot(
                      controller: _screenshotController,
                      child: AnimatedContainer(
                        padding: const EdgeInsets.only(
                          top: AppPadding.padding_20,
                          left: AppPadding.padding_20,
                          right: AppPadding.padding_20,
                        ),
                        color: lyricBgColor,
                        duration: Duration(milliseconds: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///HEADER
                            buildPageHeader(context),
                            SizedBox(height: AppMargin.margin_32),

                            ///LYRIC SCROLL LIST
                            Expanded(
                              child: buildLyricList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppMargin.margin_8),

                  ///PLAY PAUSE AND SHARE
                  buildQueuePageControls(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder buildPageHeader(BuildContext context) {
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, state) {
        if (state != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppCard(
                radius: 4.0,
                child: CachedNetworkImage(
                  width: AppValues.lyricFullPageSongItemSize,
                  height: AppValues.lyricFullPageSongItemSize,
                  fit: BoxFit.cover,
                  imageUrl: AppApi.baseUrl + state.albumArt.imageMediumPath,
                  placeholder: (context, url) => buildImagePlaceHolder(),
                  errorWidget: (context, url, e) => buildImagePlaceHolder(),
                ),
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: AutoSizeText(
                        L10nUtil.translateLocale(state.songName, context),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontSizes.font_size_18,
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        minFontSize: AppFontSizes.font_size_16,
                        maxFontSize: AppFontSizes.font_size_16,
                        overflowReplacement: Marquee(
                          text:
                              L10nUtil.translateLocale(state.songName, context),
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: AppPadding.padding_32,
                          velocity: 50.0,
                          pauseAfterRound: Duration(seconds: 2),
                          startPadding: AppPadding.padding_16,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.easeIn,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                          showFadingOnlyWhenScrolling: false,
                          fadingEdgeEndFraction: 0.2,
                          fadingEdgeStartFraction: 0.2,
                        ),
                      ),
                    ),
                    Text(
                      PagesUtilFunctions.getArtistsNames(
                          state.artistsName, context),
                      maxLines: 1,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              Visibility(
                visible: !showAppLogo,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: CircleAvatar(
                    radius: AppValues.lyricPageCloseButtonSize,
                    backgroundColor: AppColors.white.withOpacity(0.4),
                    child: Icon(
                      FlutterRemix.close_line,
                      size: AppValues.lyricPageCloseButtonSize - 2,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showAppLogo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.icAppSmallIcon,
                      width: AppIconSizes.icon_size_4.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: AppMargin.margin_8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LYRIC BY".toUpperCase(),
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_8.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Mehaley".toUpperCase(),
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_10.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  BlocConsumer<LyricBloc, LyricState> buildLyricList() {
    return BlocConsumer<LyricBloc, LyricState>(
      listener: (context, state) {
        if (state is LyricDataLoaded) {
          if (state.lyricList.length < 1 ||
              state.songId != widget.song.songId) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        if (state is LyricDataLoaded) {
          if (state.lyricList.length > 0 &&
              state.songId == widget.song.songId) {
            return BlocListener<SongPositionCubit, CurrentPlayingPosition>(
              listener: (context, duration) {
                //LISTEN TO LYRIC AND DURATION CHANGES
                try {
                  if (state.lyricList.length > 0) {
                    LyricItem lyricItem = state.lyricList.firstWhere((element) {
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
                    if (state.lyricList.length > lyricItem.index) {
                      lyricScrollController.scrollTo(
                        index: lyricItem.index,
                        duration: Duration(milliseconds: 0),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                } catch (e) {}
                //LISTEN TO LYRIC AND DURATION CHANGES
              },
              child: ShaderMask(
                blendMode: BlendMode.dstOut,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.dominantColor,
                      Colors.transparent,
                      Colors.transparent,
                      widget.dominantColor,
                    ],
                    stops: [0.0, 0.05, 0.95, 1.0],
                  ).createShader(bounds);
                },
                child: ScrollablePositionedList.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.lyricList.length,
                  itemBuilder: (context, index) {
                    return Text(
                      getLyricItemText(state.lyricList, index),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_16.sp,
                        color: currentLyricItem != null
                            ? (currentLyricItem!.index == index
                                ? AppColors.black
                                : AppColors.white.withOpacity(0.7))
                            : AppColors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                  itemScrollController: lyricScrollController,
                  itemPositionsListener: lyricPositionsListener,
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        }
        return SizedBox();
      },
    );
  }

  Padding buildQueuePageControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPadding.padding_20,
        right: AppPadding.padding_20,
        bottom: AppPadding.padding_32,
      ),
      child: BlocBuilder<CurrentPlayingCubit, Song?>(
        builder: (context, currentPlayingState) {
          if (currentPlayingState != null) {
            return Column(
              children: [
                ///SLIDER
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.white,
                    inactiveTrackColor: ColorUtil.darken(
                      AppColors.lightGrey,
                      0.1,
                    ),
                    trackShape: CustomTrackShapeThin(),
                    thumbColor: AppColors.lightGrey,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: AppIconSizes.icon_size_6,
                    ),
                    overlayColor: AppColors.lightGrey.withOpacity(0.05),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
                  ),
                  child: BlocBuilder<SongPositionCubit, CurrentPlayingPosition>(
                    builder: (context, state) {
                      return Slider(
                        value: AudioPlayerUtil.getCorrectProgress(
                          state.currentDuration.inSeconds.toDouble(),
                          currentPlayingState.audioFile.audioDurationSeconds,
                        ),
                        min: 0.0,
                        max: PagesUtilFunctions.getSongLength(
                          currentPlayingState,
                        ),
                        onChanged: (value) {
                          BlocProvider.of<AudioPlayerBloc>(context).add(
                            SeekAudioPlayerEvent(
                              skipToDuration: Duration(seconds: value.toInt()),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                ///SONG PROGRESS TEXTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<SongPositionCubit, CurrentPlayingPosition>(
                      builder: (context, state) {
                        return Text(
                          PagesUtilFunctions.formatSongDurationTimeTo(
                            Duration(
                                seconds:
                                    state.currentDuration.inSeconds.toInt()),
                          ),
                          style: TextStyle(
                            fontSize: AppFontSizes.font_size_8.sp,
                            color: AppColors.lightGrey,
                          ),
                        );
                      },
                    ),
                    Text(
                      PagesUtilFunctions.getFormatdMaxSongDuration(
                        currentPlayingState,
                      ),
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_8.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),

                ///PLAYER CONTROLS
                Container(
                  height: ScreenUtil(context: context).getScreenHeight() * 0.07,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: BlocBuilder<PlayPauseCubit, bool>(
                          builder: (context, state) {
                            return AppBouncingButton(
                              onTap: () {
                                BlocProvider.of<AudioPlayerBloc>(context).add(
                                  PlayPauseEvent(),
                                );
                              },
                              child: Icon(
                                state
                                    ? Icons.pause_circle_filled_sharp
                                    : FlutterRemix.play_circle_fill,
                                size: AppIconSizes.icon_size_72,
                                color: AppColors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Center(
                          child: ShareBtnWidget(
                            onTap: () async {
                              setState(() {
                                showAppLogo = true;
                                animPadding = AppPadding.padding_16;
                                lyricBgColor = ColorUtil.lighten(
                                  ColorUtil.changeColorSaturation(
                                      dominantColor, 0.8),
                                  0.15,
                                );
                              });
                              Future.delayed(Duration(milliseconds: 100), () {
                                setState(() {
                                  lyricBgColor = ColorUtil.darken(
                                    ColorUtil.changeColorSaturation(
                                        dominantColor, 0.8),
                                    0.15,
                                  );
                                  animPadding = 0;
                                });
                              });
                              await _screenshotController
                                  .capture(
                                      delay: const Duration(milliseconds: 10),
                                      pixelRatio: ScreenUtil(context: context)
                                          .getPixelRatio())
                                  .then(
                                (value) {
                                  BlocProvider.of<ShareBloc>(context).add(
                                    ShareLyricEvent(
                                      lyricScreenShotFile: value,
                                      song: widget.song,
                                      subject:
                                          '${L10nUtil.translateLocale(widget.song.songName, context)}\n${PagesUtilFunctions.getArtistsNames(widget.song.artistsName, context)}',
                                    ),
                                  );
                                },
                              );
                              setState(() {
                                showAppLogo = false;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
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

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
