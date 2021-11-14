import 'package:auto_size_text/auto_size_text.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/loop_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/muted_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/shuffle_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/custom_track_shape.dart';
import 'package:elf_play/ui/common/like_follow/song_favorite_button.dart';
import 'package:elf_play/ui/common/song_item/song_download_indicator.dart';
import 'package:elf_play/util/audio_player_util.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:sizer/sizer.dart';import 'package:elf_play/app_language/app_locale.dart';

import '../queue_list_page.dart';

class MainPlayerControls extends StatefulWidget {
  const MainPlayerControls({Key? key}) : super(key: key);

  @override
  _MainPlayerControlsState createState() => _MainPlayerControlsState();
}

class _MainPlayerControlsState extends State<MainPlayerControls> {
  //AUDIO PLAYER PLAYBACK STATE CHANGES
  double progress = 0.0;
  double bufferedPosition = 0.0;
  double totalDuration = 0.0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SongPositionCubit, CurrentPlayingPosition>(
          listener: (context, state) {
            progress = state.currentDuration.inSeconds.toDouble();
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
        padding: EdgeInsets.symmetric(horizontal: AppMargin.margin_16),
        child: Column(
          children: [
            BlocBuilder<CurrentPlayingCubit, Song?>(
              builder: (context, state) {
                if (state != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                              child: AutoSizeText(
                                L10nUtil.translateLocale(
                                    state.songName, context),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppFontSizes.font_size_18,
                                  color: AppColors.white,
                                ),
                                maxLines: 1,
                                minFontSize: AppFontSizes.font_size_18,
                                maxFontSize: AppFontSizes.font_size_18,
                                overflowReplacement: Marquee(
                                  text: L10nUtil.translateLocale(
                                      state.songName, context),
                                  style: TextStyle(
                                    fontSize: AppFontSizes.font_size_18,
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
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                  showFadingOnlyWhenScrolling: false,
                                  fadingEdgeEndFraction: 0.2,
                                  fadingEdgeStartFraction: 0.2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: AppMargin.margin_2,
                            ),
                            Text(
                              PagesUtilFunctions.getArtistsNames(
                                state.artistsName,
                                context,
                              ),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_10.sp,
                                color: AppColors.lightGrey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///DOWNLOAD STATES IF BOUGHT
                      SongDownloadIndicator(
                        key: Key(state.songId.toString()),
                        song: state,
                        isForPlayerPage: true,
                      ),

                      ///FAV BUTTON
                      SongFavoriteButton(
                        songId: state.songId,
                        isLiked: state.isLiked,
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: AppMargin.margin_4,
            ),
            //SLIDER
            BlocBuilder<CurrentPlayingCubit, Song?>(
              builder: (context, currentPlayingState) {
                if (currentPlayingState != null) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.lightGrey,
                      inactiveTrackColor: AppColors.lightGrey.withOpacity(0.24),
                      trackShape: CustomTrackShape(),
                      trackHeight: 2.0,
                      thumbColor: AppColors.white,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayColor: AppColors.white.withOpacity(0.24),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 16.0),
                    ),
                    child:
                        BlocBuilder<SongPositionCubit, CurrentPlayingPosition>(
                      builder: (context, state) {
                        return Slider(
                          value: AudioPlayerUtil.getCorrectProgress(
                            state.currentDuration.inSeconds.toDouble(),
                            currentPlayingState.audioFile.audioDurationSeconds,
                          ),
                          min: 0.0,
                          max: PagesUtilFunctions.getSongLength(
                              currentPlayingState),
                          onChanged: (value) {
                            BlocProvider.of<AudioPlayerBloc>(context).add(
                              SeekAudioPlayerEvent(
                                skipToDuration:
                                    Duration(seconds: value.toInt()),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        color: AppColors.lightGrey.withOpacity(0.7),
                      ),
                    );
                  },
                ),
                BlocBuilder<CurrentPlayingCubit, Song?>(
                  builder: (context, currentPlayingState) {
                    if (currentPlayingState != null) {
                      return Text(
                        PagesUtilFunctions.getFormatdMaxSongDuration(
                          currentPlayingState,
                        ),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          color: AppColors.lightGrey.withOpacity(0.7),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
            //PLAYER PLAY PAUSE AND OTHER BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<ShuffleCubit, bool>(
                  builder: (context, state) {
                    return AppBouncingButton(
                      onTap: () {
                        BlocProvider.of<AudioPlayerBloc>(context)
                            .add(ShufflePlayerQueueEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.padding_16),
                        child: Column(
                          children: [
                            Icon(
                              PhosphorIcons.shuffle_light,
                              color: state ? AppColors.green : AppColors.white,
                              size: AppIconSizes.icon_size_20,
                            ),
                            state
                                ? Icon(
                                    Icons.circle,
                                    color: AppColors.darkGreen,
                                    size: AppIconSizes.icon_size_4,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                AppBouncingButton(
                  onTap: () {
                    BlocProvider.of<AudioPlayerBloc>(context)
                        .add(PlayPreviousSongEvent());
                  },
                  child: Icon(
                    Icons.skip_previous_sharp,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_48,
                  ),
                ),
                BlocBuilder<PlayPauseCubit, bool>(
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
                AppBouncingButton(
                  onTap: () {
                    BlocProvider.of<AudioPlayerBloc>(context)
                        .add(PlayNextSongEvent());
                  },
                  child: Icon(
                    Icons.skip_next_sharp,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_48,
                  ),
                ),
                BlocBuilder<LoopCubit, LoopMode>(
                  builder: (context, state) {
                    return AppBouncingButton(
                      onTap: () {
                        BlocProvider.of<AudioPlayerBloc>(context)
                            .add(LoopPlayerQueueEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.padding_16),
                        child: Column(
                          children: [
                            Icon(
                              PagesUtilFunctions.getLoopIcon(state),
                              color:
                                  PagesUtilFunctions.getLoopButtonColor(state),
                              size: AppIconSizes.icon_size_20,
                            ),
                            state != LoopMode.off
                                ? Icon(
                                    Icons.circle,
                                    size: AppIconSizes.icon_size_4,
                                    color: AppColors.darkGreen,
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            // SizedBox(
            //   height: AppMargin.margin_8,
            // ),
            //player cast and playlist buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<IsMutedCubit, bool>(
                  builder: (context, state) {
                    return AppBouncingButton(
                      onTap: () {
                        BlocProvider.of<AudioPlayerBloc>(context)
                            .add(SetMutedEvent());
                      },
                      child: Padding(
                        padding: EdgeInsets.all(AppPadding.padding_16),
                        child: Icon(
                          state
                              ? PhosphorIcons.speaker_slash_light
                              : PhosphorIcons.speaker_high_thin,
                          color: AppColors.lightGrey,
                          size: AppIconSizes.icon_size_20,
                        ),
                      ),
                    );
                  },
                ),
                AppBouncingButton(
                  onTap: () {
                    //NAVIGATE TO PLAYER QUEUE PAGE
                    Navigator.of(context, rootNavigator: true).push(
                      PagesUtilFunctions.createBottomToUpAnimatedRoute(
                        page: QueueListPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.padding_16),
                    child: Icon(
                      PhosphorIcons.playlist_thin,
                      color: AppColors.lightGrey,
                      size: AppIconSizes.icon_size_20,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
