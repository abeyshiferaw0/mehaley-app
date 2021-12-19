import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/util/screen_util.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

class TestTwoWidget extends StatefulWidget {
  const TestTwoWidget({Key? key}) : super(key: key);

  @override
  _TestTwoWidgetState createState() => _TestTwoWidgetState();
}

class _TestTwoWidgetState extends State<TestTwoWidget> {
  String name = "";
  @override
  void initState() {
    _setInitialPlaylist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil(context: context).getScreenHeight(),
      width: ScreenUtil(context: context).getScreenWidth(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(color: Colors.black),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _audioPlayer.seekToPrevious();
                  },
                  icon: Icon(Icons.skip_previous_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    _audioPlayer.stop();
                    _audioPlayer.dispose();
                    // await _audioPlayer.seek(Duration.zero, index: 0);
                    // _audioPlayer.play();
                  },
                  icon: Icon(Icons.ten_k),
                ),
                IconButton(
                  onPressed: () {
                    _audioPlayer.seekToNext();
                  },
                  icon: Icon(Icons.skip_next_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setInitialPlaylist() async {
    const prefix = 'https://www.soundhelix.com/examples/mp3';
    final song1 = Uri.parse('$prefix/SoundHelix-Song-1.mp3');
    final song2 = Uri.parse('$prefix/SoundHelix-Song-2.mp3');
    final song3 = Uri.parse('$prefix/SoundHelix-Song-3.mp3');
    ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(song1, tag: MediaItem(id: 'Song 1', title: 'Song 1')),
      AudioSource.uri(song2, tag: MediaItem(id: 'Song 2', title: 'Song 2')),
      AudioSource.uri(song3, tag: MediaItem(id: 'Song 3', title: 'Song 3')),
    ]);
    await _audioPlayer.setAudioSource(_playlist);
    await _audioPlayer.play();
    _audioPlayer.sequenceStateStream.listen((event) async {
      if (event != null) {
        setState(() {
          print(
              "event.currentSource!.tag.toString() ${event.currentSource!.tag.toString()}");
          name = event.currentSource!.tag.toString();
        });
      }
    });
  }
}
