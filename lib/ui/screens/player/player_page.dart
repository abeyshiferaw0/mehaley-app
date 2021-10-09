import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/config/fake_data.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_snack_bar.dart';
import 'package:elf_play/ui/screens/player/widgets/bg_player_gradient.dart';
import 'package:elf_play/ui/screens/player/widgets/main_player_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  //SCROLL CONTROLLER
  late ScrollController _singleChildScrollViewController;
  late bool isPagePopped;

  @override
  void initState() {
    _singleChildScrollViewController = ScrollController();
    isPagePopped = false;
    //_singleChildScrollViewController.addListener(showControls);
    //DEBUG
    // Future.delayed(
    //   Duration(microseconds: 500),
    //   () {
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         return DialogSongPreviewMode(
    //           dominantColor: AppColors.appGradientDefaultColor,
    //         );
    //       },
    //     );
    //   },
    // );
    //DEBUG
    //LOAD LYRIC
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocListener<AudioPlayerBloc, AudioPlayerState>(
        listener: playerPageListners,
        child: SingleChildScrollView(
          controller: _singleChildScrollViewController,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // if (BlocProvider.of<PlayerVideoModeCubit>(context).state) {
              //   BlocProvider.of<PlayerVideoModeRemoveControlsCubit>(context)
              //       .changeControls();
              // }
            },
            child: Container(
              child: Stack(
                children: [
                  BgPlayerGradient(),
                  // BlocBuilder<PlayerVideoModeCubit, bool>(
                  //   builder: (context, state) {
                  //     if (state) return BgShortVideo();
                  //     return SizedBox();
                  //   },
                  // ),
                  // BlocBuilder<PlayerVideoModeCubit, bool>(
                  //   builder: (context, state) {
                  //     if (state) return BgPlayerVideoGradient();
                  //     return SizedBox();
                  //   },
                  // ),
                  MainPlayerWidgets(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //_singleChildScrollViewController.removeListener(showControls);
    super.dispose();
  }

  // showControls() {
  //   setState(
  //     () {
  //       if (BlocProvider.of<PlayerVideoModeCubit>(context).state) {
  //         BlocProvider.of<PlayerVideoModeRemoveControlsCubit>(context)
  //             .showControls();
  //       }
  //     },
  //   );
  // }

  void playerPageListners(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerErrorState) {
      print("${AppTestValues.debugTxt} Error code: ${state.error}");
      print("${AppTestValues.debugTxt} Error message: ${state.msg}");
      ScaffoldMessenger.of(context).showSnackBar(
        buildAppSnackBar(
          bgColor: AppColors.errorRed,
          txtColor: AppColors.white,
          msg: state.msg,
        ),
      );
    }
    if (state is AudioPlayerCurrentSongChangeState) {
      ///POP PLAYER PAGE IF SONG NOT BOUGHT OR FREE
      if (!state.song.isFree && !state.song.isBought && !isPagePopped) {
        print(
            "AudioPlayerCurrentSongChangeStatePOPPED ${state.song.isFree}  //  ${state.song.isBought}");
        isPagePopped = true;
        Navigator.pop(context);
      }
    }
  }
}
