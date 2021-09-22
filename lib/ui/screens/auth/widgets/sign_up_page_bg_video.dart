import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SignupPageBgVideo extends StatefulWidget {
  const SignupPageBgVideo({Key? key}) : super(key: key);

  @override
  _SignupPageBgVideoState createState() => _SignupPageBgVideoState();
}

class _SignupPageBgVideoState extends State<SignupPageBgVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://kirayplc.com/ru1e7da3.upload.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.setLooping(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil(context: context).getScreenWidth(),
      height: ScreenUtil(context: context).getScreenHeight(),
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          //FURTHER IMPLEMENTATION
        ],
      ),
    );
  }
}
