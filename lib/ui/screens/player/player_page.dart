import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:mehaley/business_logic/cubits/should_show_ethio_sub_dialog_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/screens/player/widgets/bg_player_gradient.dart';
import 'package:mehaley/ui/screens/player/widgets/main_player_widgets.dart';
import 'package:mehaley/util/pages_util_functions.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ///CHECK IF NOT PURCHASED OR FREE OR OR SUBSCRIBED AND POP
      checkIfShouldPop();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///PROVIDE QUOTES BLOC TO PAGE
    return BlocProvider(
      create: (context) =>
          QuotesBloc(
            quotesDataRepository: AppRepositories.quotesDataRepository,
          ),
      child: Scaffold(
        backgroundColor: ColorMapper.getPagesBgColor(),
        body: BlocListener<AudioPlayerBloc, AudioPlayerState>(
          listener: playerPageListeners,
          child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
            builder: (context, state) {
              return SingleChildScrollView(
                controller: _singleChildScrollViewController,
                child: Container(
                  child: Stack(
                    children: [

                      ///PLAYER PAGE BG GRADIENT
                      BgPlayerGradient(),

                      ///PLAYER PAGE FRONT WIDGETS
                      MainPlayerWidgets(),
                    ],
                  ),
                ),
              );
            },
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

  void playerPageListeners(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerCurrentSongChangeState) {
      ///POP PLAYER PAGE IF SONG NOT BOUGHT OR FREE

      if (PagesUtilFunctions.isNotFreeBoughtAndSubscribed(state.song) &&
          !isPagePopped) {
        isPagePopped = true;
        Navigator.pop(context);
      }
    }
  }

  void checkIfShouldPop() async {
    print("checkIfShouldPop => 1");
    if (BlocProvider
        .of<AudioPlayerBloc>(context)
        .audioPlayer
        .sequenceState !=
        null) {
      print("checkIfShouldPop => 2");
      IndexedAudioSource? currentItem =
          BlocProvider
              .of<AudioPlayerBloc>(context)
              .audioPlayer
              .sequenceState!
              .currentSource;
      if (currentItem != null) {
        print("checkIfShouldPop => 3");
        MediaItem mediaItem = (currentItem.tag as MediaItem);
        Song song = Song.fromMap(mediaItem.extras![AppValues.songExtraStr]);
        if (PagesUtilFunctions.isNotFreeBoughtAndSubscribed(song)) {
          print("checkIfShouldPop => 4");

          ///POP PAGE IF CURRENT PLAYING IS NOT BOUGHT OR FREE
          if (!isPagePopped) {
            print("checkIfShouldPop => 5");

            Navigator.pop(context);
            isPagePopped = true;

            ///TO SHOW ETHIO SUB DIALOG
            BlocProvider.of<ShouldShowEthioSubDialogCubit>(context)
                .checkOnPlayingUnPurchasedSong();
          }
        }
      }
    }
  }
}
