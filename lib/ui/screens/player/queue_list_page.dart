import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/loop_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/shuffle_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/custom_track_shape.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/common/song_item/song_item_badge.dart';
import 'package:elf_play/ui/common/song_item/song_queue_item.dart';
import 'package:elf_play/util/audio_player_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
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
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<SongPositionCubit, Duration>(
              listener: (context, state) {
                progress = state.inSeconds.toDouble();
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
                color: AppColors.darkGrey,
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
        activeTrackColor: AppColors.lightGrey,
        inactiveTrackColor: AppColors.lightGrey.withOpacity(0.24),
        trackShape: CustomTrackShape(),
        trackHeight: 1.0,
        thumbColor: AppColors.white,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
        overlayColor: AppColors.white.withOpacity(0.24),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
      ),
      child: BlocBuilder<CurrentPlayingCubit, Song?>(
        builder: (context, currentPlayingState) {
          if (currentPlayingState != null) {
            return BlocBuilder<SongPositionCubit, Duration>(
              builder: (context, state) {
                return Slider(
                  value: AudioPlayerUtil.getCorrectProgress(
                    state.inSeconds.toDouble(),
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
                        previousDuration: state,
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
      color: AppColors.black,
      padding: EdgeInsets.symmetric(vertical: AppPadding.padding_20),
      child: Row(
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
                        color: PagesUtilFunctions.getLoopButtonColor(state),
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
    );
  }

  Widget buildNextUpItems(int index, Song song) {
    return SongQueueItem(
      key: Key("$index"),
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
          Text(
            'Queue',
            style: TextStyle(
              fontSize: AppFontSizes.font_size_16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            'Now Playing',
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
            'Next Up',
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
            Radius.circular(2),
          ),
          child: CachedNetworkImage(
            width: AppValues.artistSongItemSize,
            height: AppValues.artistSongItemSize,
            fit: BoxFit.cover,
            imageUrl: AppApi.baseFileUrl + song.albumArt.imageSmallPath,
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
                song.songName.textAm,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_12.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  song.lyricIncluded ? SongItemBadge(tag: 'LYRIC') : SizedBox(),
                  Text(
                    PagesUtilFunctions.getArtistsNames(song.artistsName),
                    style: TextStyle(
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
            'assets/lottie/playing.json',
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
