import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/play_pause_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_buffered_position_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_duration_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/dialog/dialog_song_preview_mode.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/subscribe_small_button.dart';
import 'package:mehaley/ui/screens/player/player_page.dart';
import 'package:mehaley/util/audio_player_util.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:sizer/sizer.dart';

import 'app_card.dart';
import 'like_follow/song_favorite_button.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key? key,
    required this.navigatorKey,
    required this.playerProcessingState,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final ProcessingState playerProcessingState;

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  //DOMINANT COLOR INIT
  ImageProvider? currentImageProvider;
  int? currentMediaItemId;

  //
  bool isPreviewHeaderExpanded = true;

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
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, currentPlayingSong) {
        if (currentPlayingSong != null) {
          ///SHOW SONG CHANGE WITH SLIDING ANIMATION
          animateWhenSongChange(currentPlayingSong);
          return Container(
            color: ColorMapper.getPagesBgColor(),
            child: SlideTransition(
              position: offset,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ///OPEN PLAYER PAGE IF PURCHASED OR FREE OR SUBSCRIBED
                  // final bool isUserSubscribed =
                  //     PagesUtilFunctions.isUserSubscribed();

                  if (PagesUtilFunctions.isFreeBoughtOrSubscribed(
                      currentPlayingSong)) {
                    Navigator.of(context, rootNavigator: true).push(
                      PagesUtilFunctions.createBottomToUpAnimatedRoute(
                        page: PlayerPage(),
                      ),
                    );
                  } else {
                    ///SHOW BUY OR PURCHASE DIALOG
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Center(
                          child: DialogSongPreviewMode(
                            song: currentPlayingSong,
                            isForDownload: false,
                            isForPlaying: true,
                            onSubscribeButtonClicked: () {
                              widget.navigatorKey.currentState!.pushNamed(
                                AppRouterPaths.subscriptionRoute,
                              );
                            },
                            onBuyButtonClicked: () {
                              PurchaseUtil
                                  .songPreviewModeDialogBuyButtonOnClick(
                                context,
                                currentPlayingSong,
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
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
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    duration: Duration(
                      milliseconds: AppValues.colorChangeAnimationDuration,
                    ),
                    child: Container(
                      key: ValueKey<int>(currentPlayingSong.songId),
                      color: ColorUtil.darken(
                        ColorUtil.changeColorSaturation(
                            HexColor(
                                currentPlayingSong.albumArt.primaryColorHex),
                            0.7),
                        0.1,
                      ),
                      // color: ColorUtil.changeColorSaturation(
                      //   HexColor(currentPlayingSong.albumArt.primaryColorHex),
                      //   0.8,
                      //),
                      child: Wrap(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PagesUtilFunctions.isNotFreeBoughtAndSubscribed(
                                      currentPlayingSong)
                                  ? buildPreviewModeBuyContainer(
                                      currentPlayingSong,
                                    )
                                  : SizedBox(),
                              buildPlayerControls(currentPlayingSong),
                              buildMiniPlayerSlider(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget buildPreviewModeBuyContainer(Song song) {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 300),
      dividerColor: AppColors.transparent,
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      expansionCallback: (int item, bool status) {
        setState(() {
          isPreviewHeaderExpanded = !status;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          hasIcon: false,
          backgroundColor: ColorUtil.darken(
            ColorUtil.changeColorSaturation(
                HexColor(song.albumArt.primaryColorHex), 0.7),
            0.15,
          ),
          headerBuilder: (context, isExpanded) {
            return buildPreviewModeExpansionHeader(song, isExpanded);
          },
          body: buildPreviewModeExpansionBody(song),
          isExpanded: isPreviewHeaderExpanded,
        ),
      ],
    );
  }

  Container buildPreviewModeExpansionBody(Song song) {
    return Container(
      // color: ColorUtil.darken(
      //   ColorUtil.changeColorSaturation(
      //       HexColor(song.albumArt.primaryColorHex), 0.8),
      //   0.05,
      // ),
      padding: EdgeInsets.only(
        top: AppPadding.padding_8,
        left: AppPadding.padding_8,
        bottom: AppPadding.padding_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              buildBuyButton(song),
              Expanded(
                child: SizedBox(),
              ),

              ///SUBSCRIBE SMALL BUTTON
              SubscribeSmallButton(
                text: AppLocale.of().subscribeDialogTitle,
                textColor: ColorMapper.getWhite(),
                fontSize: AppFontSizes.font_size_10,
                onTap: () {
                  widget.navigatorKey.currentState!.pushNamed(
                    AppRouterPaths.subscriptionRoute,
                  );
                },
              ),
              SizedBox(
                width: AppMargin.margin_16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildPreviewModeExpansionHeader(Song song, bool isExpanded) {
    return Container(
      color: ColorUtil.darken(
        ColorUtil.changeColorSaturation(
            HexColor(song.albumArt.primaryColorHex), 0.7),
        0.15,
      ),
      padding: EdgeInsets.only(
        top: AppPadding.padding_16,
        left: AppPadding.padding_8,
        right: AppPadding.padding_8,
        bottom: AppPadding.padding_8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.of().previewMode.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppFontSizes.font_size_10.sp,
                    color: ColorMapper.getWhite(),
                  ),
                ),
                SizedBox(
                  height: AppMargin.margin_4,
                ),
                Text(
                  AppLocale.of().uAreListingToPreviewDesc,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.font_size_8.sp,
                    color: ColorMapper.getLightGrey(),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isExpanded
                ? FlutterRemix.arrow_down_s_line
                : FlutterRemix.arrow_up_s_line,
            size: AppIconSizes.icon_size_24,
            color: ColorMapper.getWhite(),
          ),
        ],
      ),
    );
  }

  Container buildPlayerControls(Song currentPlayingSong) {
    return Container(
      margin: EdgeInsets.all(AppMargin.margin_8),
      child: Row(
        children: [
          buildMiniAlbumArt(currentPlayingSong),
          SizedBox(width: AppMargin.margin_8),
          buildTrackTitle(currentPlayingSong),
          SizedBox(width: AppMargin.margin_4),
          buildMiniPlayerIcons(
            currentPlayingSong.songId,
            currentPlayingSong.isLiked,
          )
        ],
      ),
    );
  }

  Row buildMiniPlayerIcons(int id, bool isLiked) {
    return Row(
      children: [
        ///PREVIOUS BUTTON
        BlocBuilder<PlayerQueueCubit, QueueAndIndex>(
          builder: (context, state) {
            if (state.queue.length > 0 && state.currentIndex > 0) {
              return AppBouncingButton(
                onTap: () {
                  BlocProvider.of<AudioPlayerBloc>(context)
                      .add(PlayPreviousSongEvent());
                },
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    FlutterRemix.skip_back_mini_fill,
                    size: AppIconSizes.icon_size_28,
                    color: ColorMapper.getWhite(),
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),

        ///PLAY PAUSE BUTTON
        BlocBuilder<PlayPauseCubit, bool>(
          builder: (context, state) {
            if (widget.playerProcessingState == ProcessingState.loading) {
              return Container(
                width: AppIconSizes.icon_size_16,
                height: AppIconSizes.icon_size_16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorMapper.getWhite(),
                ),
              );
            } else {
              return AppBouncingButton(
                onTap: () {
                  BlocProvider.of<AudioPlayerBloc>(context).add(
                    PlayPauseEvent(),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    state
                        ? FlutterRemix.pause_mini_fill
                        : FlutterRemix.play_fill,
                    size: AppIconSizes.icon_size_28,
                    color: ColorMapper.getWhite(),
                  ),
                ),
              );
            }
          },
        ),

        ///NEXT BUTTON
        BlocBuilder<PlayerQueueCubit, QueueAndIndex>(
          builder: (context, state) {
            if (state.queue.length > 0 &&
                (state.queue.length - 1) > state.currentIndex) {
              return AppBouncingButton(
                onTap: () {
                  BlocProvider.of<AudioPlayerBloc>(context).add(
                    PlayNextSongEvent(),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    FlutterRemix.skip_forward_mini_fill,
                    size: AppIconSizes.icon_size_28,
                    color: ColorMapper.getWhite(),
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),

        ///FAVORITE BUTTON
        SongFavoriteButton(
          songId: id,
          isLiked: isLiked,
          likedColor: ColorMapper.getWhite(),
          unlikedColor: ColorMapper.getWhite(),
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
              song != null
                  ? L10nUtil.translateLocale(song.songName, context)
                  : '',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: AppFontSizes.font_size_16,
                color: ColorMapper.getWhite(),
              ),
              maxLines: 1,
              minFontSize: AppFontSizes.font_size_16,
              maxFontSize: AppFontSizes.font_size_16,
              overflowReplacement: Marquee(
                text: song != null
                    ? L10nUtil.translateLocale(song.songName, context)
                    : '',
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16,
                  fontWeight: FontWeight.w600,
                  color: ColorMapper.getWhite(),
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
                ? PagesUtilFunctions.getArtistsNames(song.artistsName, context)
                : '',
            style: TextStyle(
              color: ColorMapper.getLightGrey(),
              fontSize: AppFontSizes.font_size_8.sp,
            ),
          )
        ],
      ),
    );
  }

  AppCard buildMiniAlbumArt(Song? song) {
    return AppCard(
      radius: 4.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl: song != null ? song.albumArt.imageSmallPath : '',
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
        if (currentPlayingState != null) {
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: ColorMapper.getBlack(),
              inactiveTrackColor: ColorMapper.getDarkGrey().withOpacity(0.5),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
              trackHeight: AppValues.miniPlayerTrackHeight,
            ),
            child: BlocConsumer<SongPositionCubit, CurrentPlayingPosition>(
              listener: (context, state) {
                ///PAUSE AND RELOAD PLAYER IF CURRENT PLAYING IS PREVIEW MODE
                if (PagesUtilFunctions.isNotFreeBoughtAndSubscribed(
                    currentPlayingState)) {
                  double songDuration =
                      currentPlayingState.audioFile.audioPreviewDurationSeconds;
                  int currentDuration = state.currentDuration.inSeconds;
                  if ((currentDuration < songDuration) &&
                      (currentDuration > (songDuration - 2))) {
                    BlocProvider.of<AudioPlayerBloc>(context).add(
                      ReloadAndPausePlayerEvent(),
                    );
                  }
                }
              },
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
          );
        } else {
          return SizedBox();
        }
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

  buildBuyButton(Song song) {
    return Builder(
      builder: (BuildContext builderContext) {
        return AppBouncingButton(
          onTap: () async {
            PurchaseUtil.miniPlayerBuyButtonOnClick(context, song);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
              vertical: AppPadding.padding_8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
              color: ColorMapper.getBlack(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocale.of().buyMezmur.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFontSizes.font_size_10.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorMapper.getWhite(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}
