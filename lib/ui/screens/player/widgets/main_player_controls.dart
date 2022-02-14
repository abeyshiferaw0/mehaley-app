import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/share_bloc/share_buttons_bloc/share_buttons_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/loop_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/muted_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/shuffle_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/custom_track_shape.dart';
import 'package:mehaley/ui/common/like_follow/song_favorite_button.dart';
import 'package:mehaley/ui/common/menu/song_menu_widget.dart';
import 'package:mehaley/ui/common/song_item/song_download_indicator.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:sizer/sizer.dart';

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
            ///SONG ACTIONS(MENU,FAV,SHARE)
            BlocBuilder<CurrentPlayingCubit, Song?>(
              builder: (context, state) {
                if (state != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///SHARE BUTTON
                      AppBouncingButton(
                        onTap: () {
                          BlocProvider.of<ShareButtonsBloc>(context).add(
                            ShareSongEvent(song: state),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(AppPadding.padding_4),
                          child: Icon(
                            FlutterRemix.share_line,
                            color: AppColors.white,
                            size: AppIconSizes.icon_size_24,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppMargin.margin_32,
                      ),

                      ///MENU BUTTON
                      AppBouncingButton(
                        onTap: () {
                          //SHOW MENU DIALOG
                          PagesUtilFunctions.showMenuSheet(
                            context: context,
                            child: SongMenuWidget(
                              song: state,
                              isForMyPlaylist: false,
                              onSubscribeButtonClicked: () {
                                ///GO TO SUBSCRIPTION PAGE
                                Navigator.pushNamed(
                                  context,
                                  AppRouterPaths.subscriptionRoute,
                                );
                              },
                              onCreateWithSongSuccess:
                                  (MyPlaylist myPlaylist) {},
                              onSongBuyClicked: () {
                                PurchaseUtil.songMenuBuyButtonOnClick(
                                  context,
                                  state,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: AppIconSizes.icon_size_48,
                          height: AppIconSizes.icon_size_48,
                          child: Stack(
                            children: [
                              // Icon(
                              //   FlutterRemix.checkbox_blank_circle_line,
                              //   color: AppColors.lightGrey,
                              //   size: AppIconSizes.icon_size_64,
                              // ),
                              Container(
                                width: AppIconSizes.icon_size_48,
                                height: AppIconSizes.icon_size_48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                    width: 1.3,
                                    color: AppColors.lightGrey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  FlutterRemix.more_2_line,
                                  color: AppColors.lightGrey,
                                  size: AppIconSizes.icon_size_32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppMargin.margin_28,
                      ),

                      ///FAV BUTTON
                      SongFavoriteButton(
                        songId: state.songId,
                        isLiked: state.isLiked,
                        likedColor: AppColors.white,
                        unlikedColor: AppColors.white,
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),

            ///SONG DURATION TEXT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<SongPositionCubit, CurrentPlayingPosition>(
                  builder: (context, state) {
                    return Text(
                      PagesUtilFunctions.formatSongDurationTimeTo(
                        Duration(
                          seconds: state.currentDuration.inSeconds.toInt(),
                        ),
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

            ///SLIDER DURATION
            BlocBuilder<CurrentPlayingCubit, Song?>(
              builder: (context, currentPlayingState) {
                if (currentPlayingState != null) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.lightGrey,
                      inactiveTrackColor: AppColors.lightGrey.withOpacity(0.4),
                      trackShape: CustomTrackShape(),
                      trackHeight: 2.0,
                      thumbColor: AppColors.white,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayColor: AppColors.lightGrey.withOpacity(0.24),
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

            // SizedBox(
            //   height: 1.h,
            // ),

            ///SONG TITLE, ARTIST NAME
            BlocBuilder<CurrentPlayingCubit, Song?>(
              builder: (context, state) {
                if (state != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 2.5.h,
                        child: AutoSizeText(
                          L10nUtil.translateLocale(
                            state.songName,
                            context,
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: AppFontSizes.font_size_16,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          minFontSize: AppFontSizes.font_size_14,
                          maxFontSize: AppFontSizes.font_size_16,
                          overflowReplacement: Marquee(
                            text: L10nUtil.translateLocale(
                              state.songName,
                              context,
                            ),
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_16,
                              fontWeight: FontWeight.w600,
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
                      SizedBox(
                        height: AppMargin.margin_2,
                      ),
                      Text(
                        PagesUtilFunctions.getArtistsNames(
                          state.artistsName,
                          context,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          color: AppColors.lightGrey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),

            SizedBox(
              height: 1.h,
            ),

            ///PLAYER PLAY PAUSE AND OTHER BUTTONS
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
                              FlutterRemix.shuffle_line,
                              color: state
                                  ? AppColors.white
                                  : AppColors.white.withOpacity(0.5),
                              size: AppIconSizes.icon_size_20,
                            ),
                            state
                                ? Icon(
                                    Icons.circle,
                                    color: AppColors.white,
                                    size: AppIconSizes.icon_size_4,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                ///PREVIOUS BUTTON
                AppBouncingButton(
                  onTap: () {
                    BlocProvider.of<AudioPlayerBloc>(context)
                        .add(PlayPreviousSongEvent());
                    // BlocProvider.of<AudioPlayerBloc>(context)
                    //     .audioPlayer
                    //     .seekToPrevious();
                  },
                  child: Icon(
                    Icons.skip_previous_sharp,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_32,
                  ),
                ),

                ///PLAY PAUSE BUTTON
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
                        size: AppIconSizes.icon_size_64,
                        color: AppColors.white,
                      ),
                    );
                  },
                ),

                ///NEXT BUTTON
                AppBouncingButton(
                  onTap: () {
                    BlocProvider.of<AudioPlayerBloc>(context).add(
                      PlayNextSongEvent(),
                    );
                    // BlocProvider.of<AudioPlayerBloc>(context)
                    //     .audioPlayer
                    //     .seekToNext()
                    //     .catchError(
                    //   (e) {
                    //     ////print("PlayNextSongEvent ${e.toString()}");
                    //   },
                    // );
                  },
                  child: Icon(
                    Icons.skip_next_sharp,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_32,
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
                              color: PagesUtilFunctions.getLoopDarkButtonColor(
                                state,
                              ),
                              size: AppIconSizes.icon_size_20,
                            ),
                            state != LoopMode.off
                                ? Icon(
                                    Icons.circle,
                                    size: AppIconSizes.icon_size_4,
                                    color: AppColors.white,
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

            SizedBox(
              height: 1.h,
            ),

            ///MUTE AND QUEUE BUTTONS
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
                              ? FlutterRemix.volume_mute_line
                              : FlutterRemix.volume_up_line,
                          color: AppColors.lightGrey,
                          size: AppIconSizes.icon_size_20,
                        ),
                      ),
                    );
                  },
                ),

                ///SONG DOWNLOAD INDICATOR
                BlocBuilder<CurrentPlayingCubit, Song?>(
                  builder: (context, state) {
                    if (state != null) {
                      return SongDownloadIndicator(
                        key: Key(state.songId.toString()),
                        song: state,
                        isForPlayerPage: true,
                        downloadingFailedColor:
                            AppColors.lightGrey.withOpacity(0.5),
                        downloadingColor: AppColors.lightGrey,
                        downloadedColor: AppColors.white,
                      );
                    } else {
                      return SizedBox();
                    }
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
                      FlutterRemix.play_list_line,
                      color: AppColors.lightGrey,
                      size: AppIconSizes.icon_size_20,
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
