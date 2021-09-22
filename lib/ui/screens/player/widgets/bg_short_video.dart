import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/fake_data.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class BgShortVideo extends StatefulWidget {
  const BgShortVideo({Key? key}) : super(key: key);

  @override
  _BgShortVideoState createState() => _BgShortVideoState();
}

class _BgShortVideoState extends State<BgShortVideo> {
  //VIDEO CONTROLLER
  late VideoPlayerController _controller;
  //SHOW THUMBNAIL
  bool showThumbnail = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(AppTestValues.textBgVideo)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setVolume(0.0);
    _controller.setLooping(true);
    _controller.play();

    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        setState(() {
          showThumbnail = true;
        });
      } else {
        setState(() {
          showThumbnail = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: ScreenUtil(context: context).getScreenWidth(),
          height: ScreenUtil(context: context).getScreenHeight(),
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        Visibility(
          visible: showThumbnail,
          child: BlocBuilder<CurrentPlayingCubit, Song?>(
            builder: (context, state) {
              return CachedNetworkImage(
                width: ScreenUtil(context: context).getScreenWidth(),
                height: ScreenUtil(context: context).getScreenHeight(),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => buildImagePlaceHolder(),
                placeholder: (context, url) => buildImagePlaceHolder(),
                imageUrl: state != null
                    ? AppApi.baseFileUrl + state.albumArt.imageMediumPath
                    : '',
              );
            },
          ),
        ),
      ],
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
