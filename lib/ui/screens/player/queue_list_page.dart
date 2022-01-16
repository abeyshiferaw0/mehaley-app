import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/loop_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/shuffle_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/custom_track_shape.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/song_item/song_item_badge.dart';
import 'package:mehaley/ui/common/song_item/song_queue_item.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class QueueListPage extends StatefulWidget {
  const QueueListPage({Key? key}) : super(key: key);

  @override
  _QueueListPageState createState() => _QueueListPageState();
}

class _QueueListPageState extends State<QueueListPage> {
  //AUDIO PLAYER PLAYBACK STATE CHANGES
  double progress = 0.0;
  double bufferedPosition = 0.0;
  double totalDuration = 0.0;

  //QUEUE;
  final List<Song> queue = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pagesBgColor,
      body: SafeArea(
        child: MultiBlocListener(
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
          child: Column(
            children: [
              buildNowPlayingAndNextUp(),
              buildQueuePageSlider(context),
              buildQueuePageControls(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildNowPlayingAndNextUp() {
    return Expanded(
      child: BlocBuilder<PlayerQueueCubit, QueueAndIndex>(
        builder: (context, state) {
          queue.clear();
          var i = 0;
          state.queue.forEach((element) {
            if (i > state.currentIndex) {
              queue.add(element);
            }
            i++;
          });
          return ReorderableListView.builder(
            itemCount: queue.length,
            proxyDecorator: (widget, int, animation) {
              return Container(
                color: AppColors.lightGrey,
                child: widget,
              );
            },
            header: buildQueueHeader(state.queue[state.currentIndex]),
            itemBuilder: (BuildContext context, int index) {
              return buildNextUpItems(
                index,
                queue.elementAt(index),
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              onReorder(oldIndex, newIndex, queue);
            },
          );
        },
      ),
    );
  }

  SliderTheme buildQueuePageSlider(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.darkGrey,
        inactiveTrackColor: AppColors.darkGrey.withOpacity(0.24),
        trackShape: CustomTrackShape(),
        trackHeight: 1.0,
        thumbColor: AppColors.black,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
        overlayColor: AppColors.black.withOpacity(0.24),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
      ),
      child: BlocBuilder<CurrentPlayingCubit, Song?>(
        builder: (context, currentPlayingState) {
          if (currentPlayingState != null) {
            return BlocBuilder<SongPositionCubit, CurrentPlayingPosition>(
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
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  Container buildQueuePageControls(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///SHUFFLE BUTTON
          BlocBuilder<ShuffleCubit, bool>(
            builder: (context, state) {
              return AppBouncingButton(
                onTap: () {
                  BlocProvider.of<AudioPlayerBloc>(context).add(
                    ShufflePlayerQueueEvent(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.padding_16),
                  child: Column(
                    children: [
                      Icon(
                        FlutterRemix.shuffle_line,
                        color: state ? AppColors.darkOrange : AppColors.black,
                        size: AppIconSizes.icon_size_24,
                      ),
                      state
                          ? Icon(
                              Icons.circle,
                              color: AppColors.darkOrange,
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
            },
            child: Icon(
              Icons.skip_previous_sharp,
              color: AppColors.black,
              size: AppIconSizes.icon_size_48,
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
                  size: AppIconSizes.icon_size_72,
                  color: AppColors.black,
                ),
              );
            },
          ),

          ///NEXT BUTTON
          AppBouncingButton(
            onTap: () {
              BlocProvider.of<AudioPlayerBloc>(context)
                  .add(PlayNextSongEvent());
            },
            child: Icon(
              Icons.skip_next_sharp,
              color: AppColors.black,
              size: AppIconSizes.icon_size_48,
            ),
          ),

          ///LOOP BUTTON
          BlocBuilder<LoopCubit, LoopMode>(
            builder: (context, state) {
              return AppBouncingButton(
                onTap: () {
                  BlocProvider.of<AudioPlayerBloc>(context).add(
                    LoopPlayerQueueEvent(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.padding_16),
                  child: Column(
                    children: [
                      Icon(
                        PagesUtilFunctions.getLoopIcon(state),
                        color:
                            PagesUtilFunctions.getLoopLightButtonColor(state),
                        size: AppIconSizes.icon_size_24,
                      ),
                      state != LoopMode.off
                          ? Icon(
                              Icons.circle,
                              size: AppIconSizes.icon_size_4,
                              color: AppColors.darkOrange,
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
    );
  }

  Widget buildNextUpItems(int index, Song song) {
    return SongQueueItem(
      key: Key('$index'),
      position: index + 1,
      song: song,
      onPressed: () {
        //OPEN SONG
        // PagesUtilFunctions.openMediaItem(
        //   context: context,
        //   mediaItem: mediaItem,
        //   startPlaying: true,
        //   index: 0,
        // );
      },
    );
  }

  Container buildQueueHeader(Song song) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.margin_16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppMargin.margin_16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocale.of().queue,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              Expanded(child: SizedBox()),
              Platform.isIOS
                  ? AppBouncingButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        FlutterRemix.close_line,
                        size: AppIconSizes.icon_size_24,
                        color: AppColors.black,
                      ),
                    )
                  : SizedBox()
            ],
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            AppLocale.of().nowPlaying,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          buildNowPlayingItem(song),
          SizedBox(height: AppMargin.margin_32),
          Text(
            AppLocale.of().nextUp,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.txtGrey,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
        ],
      ),
    );
  }

  Row buildNowPlayingItem(Song song) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          child: CachedNetworkImage(
            width: AppValues.queueSongItemSize + 10,
            height: AppValues.queueSongItemSize + 10,
            fit: BoxFit.cover,
            imageUrl:  song.albumArt.imageSmallPath,
            placeholder: (context, url) => buildImagePlaceHolder(),
            errorWidget: (context, url, e) => buildImagePlaceHolder(),
          ),
        ),
        SizedBox(width: AppMargin.margin_16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10nUtil.translateLocale(song.songName, context),
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_12.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  song.lyricIncluded
                      ? SongItemBadge(tag: AppLocale.of().lyrics)
                      : SizedBox(),
                  Text(
                    PagesUtilFunctions.getArtistsNames(
                      song.artistsName,
                      context,
                    ),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: AppFontSizes.font_size_10.sp,
                      color: AppColors.txtGrey,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(width: AppMargin.margin_16),
        Container(
          width: AppIconSizes.icon_size_24,
          height: AppIconSizes.icon_size_24,
          child: Lottie.asset(
            AppAssets.playingLottie,
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }

  void onReorder(int oldIndex, int newIndex, List<Song> queue) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    Song oldItem = queue.elementAt(oldIndex);
    Song newItem = queue.elementAt(newIndex);

    BlocProvider.of<AudioPlayerBloc>(context).add(
      UpdateQueueItemsMovedEvent(oldMedia: oldItem, newMedia: newItem),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
