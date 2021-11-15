import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/custom_track_shape.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/screens/player/widgets/lyric_player_full_page_widget.dart';
import 'package:mehaley/ui/screens/player/widgets/share_btn_widget.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

class LyricFullPage extends StatefulWidget {
  const LyricFullPage(
      {Key? key, required this.song, required this.dominantColor})
      : super(key: key);

  final Song song;
  final Color dominantColor;

  @override
  _LyricFullPageState createState() => _LyricFullPageState();
}

class _LyricFullPageState extends State<LyricFullPage> {
  //AUDIO PLAYER PLAYBACK STATE CHANGES
  double progress = 0.0;
  double bufferedPosition = 0.0;
  double totalDuration = 0.0;

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
        backgroundColor: widget.dominantColor,
        body: SafeArea(
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
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppPadding.padding_20,
                right: AppPadding.padding_20,
                top: AppPadding.padding_20,
                bottom: AppPadding.padding_32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildPageHeader(context),
                  SizedBox(height: AppMargin.margin_32),
                  Expanded(
                    child: LyricPlayerFullPageWidget(
                      dominantColor: widget.dominantColor,
                      song: widget.song,
                    ),
                  ),
                  SizedBox(height: AppMargin.margin_8),
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
                          fontWeight: FontWeight.w500,
                          fontSize: AppFontSizes.font_size_16,
                          color: AppColors.black,
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
                            color: AppColors.black,
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
                        fontSize: AppFontSizes.font_size_10.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppMargin.margin_16,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: CircleAvatar(
                  radius: AppValues.lyricPageCloseButtonSize,
                  backgroundColor: AppColors.white.withOpacity(0.4),
                  child: Icon(
                    PhosphorIcons.x_light,
                    size: AppValues.lyricPageCloseButtonSize - 2,
                    color: AppColors.black,
                  ),
                ),
              )
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  BlocBuilder buildQueuePageControls(BuildContext context) {
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, currentPlayingState) {
        if (currentPlayingState != null) {
          return Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.darkGrey,
                  inactiveTrackColor: AppColors.darkGrey.withOpacity(0.24),
                  trackShape: CustomTrackShapeThin(),
                  thumbColor: AppColors.black,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                  overlayColor: AppColors.black.withOpacity(0.24),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<SongPositionCubit, CurrentPlayingPosition>(
                    builder: (context, state) {
                      return Text(
                        PagesUtilFunctions.formatSongDurationTimeTo(
                          Duration(
                              seconds: state.currentDuration.inSeconds.toInt()),
                        ),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          color: AppColors.darkGrey.withOpacity(0.6),
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
                      color: AppColors.darkGrey.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
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
                              color: AppColors.black,
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
                        child: ShareBtnWidget(),
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
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
