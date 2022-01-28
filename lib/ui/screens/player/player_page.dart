import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
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
      create: (context) => QuotesBloc(
        quotesDataRepository: AppRepositories.quotesDataRepository,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pagesBgColor,
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
      final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
      if (!state.song.isFree &&
          !state.song.isBought &&
          !isUserSubscribed &&
          !isPagePopped) {
        isPagePopped = true;
        Navigator.pop(context);
      }
    }
  }

  void checkIfShouldPop() {
    if (BlocProvider.of<AudioPlayerBloc>(context).audioPlayer.sequenceState !=
        null) {
      IndexedAudioSource? currentItem =
          BlocProvider.of<AudioPlayerBloc>(context)
              .audioPlayer
              .sequenceState!
              .currentSource;
      if (currentItem != null) {
        MediaItem mediaItem = (currentItem.tag as MediaItem);
        Song song = Song.fromMap(mediaItem.extras![AppValues.songExtraStr]);
        final bool isUserSubscribed = PagesUtilFunctions.isUserSubscribed();
        if (!song.isBought && !song.isFree && !isUserSubscribed) {
          ///POP PAGE IF CURRENT PLAYING IS NOT BOUGHT OR FREE
          if (!isPagePopped) {
            Navigator.pop(context);
            isPagePopped = true;
          }
        }
      }
    }
  }
}
