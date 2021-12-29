import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/app_languages.dart';
import 'package:mehaley/ui/common/app_snack_bar.dart';
import 'package:mehaley/ui/common/song_item/song_item_video.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerPage extends StatefulWidget {
  const YouTubePlayerPage({Key? key, required this.videoLink})
      : super(key: key);

  final String videoLink;

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
    String? id = YoutubePlayer.convertUrlToId(widget.videoLink);
    if (id != null) {
      _controller = YoutubePlayerController(
        initialVideoId: id,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          captionLanguage: getCaptionLanguage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        buildAppSnackBar(
          bgColor: AppColors.errorRed,
          txtColor: AppColors.white,
          msg: 'Unable To Play Video',
          isFloating: false,
        ),
      );
      Navigator.pop(context);
    }
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
        progressIndicatorColor: AppColors.darkOrange,
        progressColors: ProgressBarColors(
          playedColor: AppColors.white,
          handleColor: AppColors.lightGrey,
          backgroundColor: AppColors.lightGrey.withOpacity(0.5),
          bufferedColor: AppColors.lightGrey.withOpacity(0.7),
        ),
        onReady: () {
          _controller.addListener(() {});
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppColors.pagesBgColor,
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
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0 ? buildTitle() : SizedBox(),
              SongItemVideo(),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: AppColors.lightGrey,
          );
        },
      ),
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
        progressIndicatorColor: AppColors.darkOrange,
        progressColors: ProgressBarColors(
          playedColor: AppColors.white,
          handleColor: AppColors.lightGrey,
          backgroundColor: AppColors.lightGrey.withOpacity(0.5),
          bufferedColor: AppColors.lightGrey.withOpacity(0.7),
        ),
        onReady: () {
          _controller.addListener(() {});
        },
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppMargin.margin_16,
        top: AppMargin.margin_32,
        bottom: AppMargin.margin_24,
      ),
      child: Text(
        "Other Videos",
        style: TextStyle(
          color: AppColors.black,
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
