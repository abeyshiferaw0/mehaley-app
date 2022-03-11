import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/videos_bloc/other_videos_bloc/other_videos_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/song_item/song_item_video.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerPage extends StatefulWidget {
  const YouTubePlayerPage({
    Key? key,
    required this.videoId,
    required this.songId,
    required this.title,
  }) : super(key: key);

  final int songId;
  final String videoId;
  final String title;

  @override
  _YouTubePlayerPageState createState() => _YouTubePlayerPageState();
}

class _YouTubePlayerPageState extends State<YouTubePlayerPage> {
  ///INITIALIZE YOUTUBE PLAYER
  late YoutubePlayerController _controller;

  ///
  bool isFullScreenEnabled = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        captionLanguage: getCaptionLanguage(),
      ),
    );
    BlocProvider.of<OtherVideosBloc>(context).add(
      LoadOtherVideosEvent(id: widget.songId),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    ///ROTATE SCREEN
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      // onExitFullScreen: () {
      //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      // },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: ColorMapper.getDarkOrange(),
        progressColors: ProgressBarColors(
          playedColor: ColorMapper.getWhite(),
          handleColor: ColorMapper.getLightGrey(),
          backgroundColor: ColorMapper.getLightGrey().withOpacity(0.5),
          bufferedColor: ColorMapper.getLightGrey().withOpacity(0.7),
        ),
        onReady: () {
          _controller.addListener(() {});
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: ColorMapper.getPagesBgColor(),
          appBar: AppBar(
            //brightness: Brightness.dark,
            systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
            backgroundColor: ColorMapper.getWhite(),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: ColorMapper.getBlack(),
              icon: Icon(
                FlutterRemix.arrow_left_line,
                size: AppIconSizes.icon_size_24,
              ),
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                fontWeight: FontWeight.w500,
                color: ColorMapper.getBlack(),
              ),
            ),
          ),
          body: Column(
            children: [
              player,
              buildOtherVideosList(),
            ],
          ),
        );
      },
    );
  }

  Expanded buildOtherVideosList() {
    return Expanded(
      child: BlocBuilder<OtherVideosBloc, OtherVideosState>(
        builder: (context, state) {
          if (state is OtherVideosLoadingState) {
            return AppLoading(size: AppValues.loadingWidgetSize * 0.7);
          }
          if (state is OtherVideosLoadedState) {
            if (state.otherVideosPageData.videoSongsList.length > 0) {
              return buildVideoList(state.otherVideosPageData.videoSongsList);
            } else {
              return buildEmptyVideoList();
            }
          }
          if (state is OtherVideosLoadingErrorState) {
            return AppError(
              bgWidget: AppLoading(
                size: AppValues.loadingWidgetSize * 0.7,
              ),
              onRetry: () {
                BlocProvider.of(context).addError(
                  LoadOtherVideosEvent(id: widget.songId),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget buildVideoList(List<Song> videoSongsList) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: videoSongsList.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0 ? buildTitle() : SizedBox(),
            SongItemVideo(
              videoSong: videoSongsList.elementAt(index),
              onTap: () {
                PagesUtilFunctions.openYtPlayerPage(
                  context,
                  videoSongsList.elementAt(index),
                  true,
                );
              },
              onOpenAudioOnly: () {
                PagesUtilFunctions.openVideoAudioOnly(
                  context,
                  videoSongsList.elementAt(index),
                  true,
                );
              },
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: ColorMapper.getLightGrey(),
        );
      },
    );
  }

  YoutubePlayerBuilder buildYoutubePlayerBuilder() {
    return YoutubePlayerBuilder(
      builder: (context, player) {
        return Container(
          child: player,
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: ColorMapper.getDarkOrange(),
        progressColors: ProgressBarColors(
          playedColor: ColorMapper.getWhite(),
          handleColor: ColorMapper.getLightGrey(),
          backgroundColor: ColorMapper.getLightGrey().withOpacity(0.5),
          bufferedColor: ColorMapper.getLightGrey().withOpacity(0.7),
        ),
        onReady: () {
          _controller.addListener(() {});
        },
      ),
    );
  }

  Container buildEmptyVideoList() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FlutterRemix.video_line,
          size: AppIconSizes.icon_size_72,
          color: ColorMapper.getLightGrey().withOpacity(0.8),
        ),
        SizedBox(
          height: AppMargin.margin_8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding_32 * 2,
          ),
          child: Text(
            AppLocale.of().cantFindOtherVideos,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: ColorMapper.getTxtGrey(),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ));
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppMargin.margin_16,
        top: AppMargin.margin_32,
        bottom: AppMargin.margin_24,
      ),
      child: Text(
        AppLocale.of().otherVideos,
        style: TextStyle(
          color: ColorMapper.getBlack(),
          fontSize: AppFontSizes.font_size_14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String getCaptionLanguage() {
    AppLanguage appLanguage = L10nUtil.getCurrentLocale();
    if (appLanguage == AppLanguage.AMHARIC) return 'am';
    if (appLanguage == AppLanguage.TIGRINYA) return 'am';
    return 'en';
  }
}
