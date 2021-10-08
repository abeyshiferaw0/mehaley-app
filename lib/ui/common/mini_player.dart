import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/screens/player/player_page.dart';
import 'package:elf_play/util/audio_player_util.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';

import 'app_card.dart';
import 'like_follow/song_favorite_button.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColorBlack;
  ImageProvider? currentImageProvider;
  int? currentMediaItemId;

  //AUDIO PLAYER PLAYBACK STATE CHANGES
  double progress = 0.0;
  double bufferedPosition = 0.0;
  double totalDuration = 0.0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
        .animate(controller);
    // controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: SlideTransition(
        position: offset,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            //OPEN PLAYER PAGE
            Navigator.of(context, rootNavigator: true).push(
              PagesUtilFunctions.createBottomToUpAnimatedRoute(
                page: PlayerPage(

                ),
              ),
            );
          },
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
            child: BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
              builder: (context, state) {
                if (state is PlayerPageDominantColorChangedState) {
                  dominantColor = ColorUtil.darken(
                    state.color,
                    0.05,
                  );
                }
                return BlocBuilder<CurrentPlayingCubit, Song?>(
                  builder: (context, state) {
                    //ANIMATE WHEN SONG CHANGE
                    animateWhenSongChange(state);
                    return AnimatedSwitcher(
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      duration: Duration(
                          milliseconds: AppValues.colorChangeAnimationDuration),
                      child: Container(
                        key: ValueKey<int>(state.hashCode),
                        color: dominantColor,
                        child: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(AppMargin.margin_8),
                                  child: Row(
                                    children: [
                                      buildMiniAlbumArt(state),
                                      SizedBox(width: AppMargin.margin_8),
                                      buildTrackTitle(state),
                                      SizedBox(width: AppMargin.margin_4),
                                      buildMiniPlayerIcons(
                                        state!.songId,
                                        state.isLiked,
                                      )
                                    ],
                                  ),
                                ),
                                buildMiniPlayerSlider(context),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Row buildMiniPlayerIcons(int id, bool isLiked) {
    return Row(
      children: [
        SongFavoriteButton(
          songId: id,
          isLiked: isLiked,
        ),
        BlocBuilder<PlayPauseCubit, bool>(
          builder: (context, state) {
            return AppBouncingButton(
              onTap: () {
                BlocProvider.of<AudioPlayerBloc>(context).add(
                  PlayPauseEvent(),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(AppPadding.padding_4),
                child: Icon(
                  state ? Icons.pause_sharp : Icons.play_arrow_sharp,
                  size: AppIconSizes.icon_size_32,
                  color: AppColors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Expanded buildTrackTitle(Song? song) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
            child: AutoSizeText(
              song != null ? song.songName.textAm : '',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_16,
                color: AppColors.white,
              ),
              maxLines: 1,
              minFontSize: AppFontSizes.font_size_16,
              maxFontSize: AppFontSizes.font_size_16,
              overflowReplacement: Marquee(
                text: song != null ? song.songName.textAm : '',
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
          Text(
            song != null
                ? PagesUtilFunctions.getArtistsNames(song.artistsName)
                : '',
            style: TextStyle(
                color: AppColors.lightGrey,
                fontSize: AppFontSizes.font_size_12),
          )
        ],
      ),
    );
  }

  AppCard buildMiniAlbumArt(Song? song) {
    return AppCard(
      radius: 0.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl: song != null
              ? AppApi.baseFileUrl + song.albumArt.imageSmallPath
              : '',
          fit: BoxFit.cover,
          height: AppValues.miniPlayerAlbumArtSize,
          width: AppValues.miniPlayerAlbumArtSize,
          imageBuilder: (context, imageProvider) {
            //CHANGE DOMINANT COLOR
            if (currentImageProvider != imageProvider) {
              currentImageProvider = imageProvider;
              // BlocProvider.of<PagesDominantColorBloc>(context).add(
              //     PlayerPageDominantColorChanged(imageProvider: imageProvider));
            }
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          placeholder: (context, url) => buildImagePlaceHolder(),
          errorWidget: (context, url, error) => buildImagePlaceHolder(),
        ),
      ),
    );
  }

  BlocBuilder buildMiniPlayerSlider(BuildContext context) {
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, currentPlayingState) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.white,
            inactiveTrackColor: AppColors.lightGrey.withOpacity(0.5),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
            trackHeight: AppValues.miniPlayerTrackHeight,
          ),
          child: BlocBuilder<SongPositionCubit, Duration>(
            builder: (context, state) {
              return Slider(
                value: AudioPlayerUtil.getCorrectProgress(
                  state.inSeconds.toDouble(),
                  currentPlayingState!.audioFile.audioDurationSeconds,
                ),
                min: 0.0,
                max: currentPlayingState.audioFile.audioDurationSeconds,
                onChanged: (value) {
                  BlocProvider.of<AudioPlayerBloc>(context).add(
                    SeekAudioPlayerEvent(
                      duration: Duration(seconds: value.toInt()),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void animateWhenSongChange(Song? song) {
    if (song != null) {
      if (currentMediaItemId == null) {
        currentMediaItemId = song.songId;
        controller.reverse().then((value) => controller.forward());
      } else {
        if (currentMediaItemId != song.songId) {
          currentMediaItemId = song.songId;
          controller.reverse().then((value) => controller.forward());
        }
      }
    }
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
