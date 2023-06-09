import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/screens/player/widgets/player_page_ad.dart';
import 'package:mehaley/util/screen_util.dart';

class MainPlayerAlbumArtPager extends StatefulWidget {
  const MainPlayerAlbumArtPager({Key? key}) : super(key: key);

  @override
  _MainPlayerAlbumArtPagerState createState() =>
      _MainPlayerAlbumArtPagerState();
}

class _MainPlayerAlbumArtPagerState extends State<MainPlayerAlbumArtPager> {
  //SONG ALBUM ART PAGE CONTROLLER
  late PageController _pageController;
  //PAGE VIEW SCROLL TRACKER
  bool isBlocScroll = false;

  @override
  void initState() {
    //INITIALIZE PAGE CONTROLLER
    initPageControllerPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocConsumer<PlayerQueueCubit, QueueAndIndex>(
      listener: (context, state) {
        isBlocScroll = true;
        if (isBlocScroll) {
          _pageController.jumpToPage(state.currentIndex);
          // _pageController.animateToPage(
          //   state.currentIndex,
          //   duration: Duration(milliseconds: 500),
          //   curve: Curves.easeIn,
          // );
          isBlocScroll = false;
        }
      },
      builder: (context, state) {
        return PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemCount: state.queue.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: AppCard(
                radius: 8,
                withShadow: true,
                constraints: BoxConstraints(
                  maxHeight:
                      ScreenUtil(context: context).getScreenHeight() * 0.4,
                  minHeight:
                      ScreenUtil(context: context).getScreenHeight() * 0.2,
                  maxWidth:
                      ScreenUtil(context: context).getScreenWidth() * 0.85,
                  minWidth: ScreenUtil(context: context).getScreenWidth() * 0.6,
                ),
                child: Stack(
                  children: [
                    buildCachedNetworkImage(state, index),
                    PlayerPageAd(),
                  ],
                ),
              ),
            );
          },
          onPageChanged: (pos) {
            // //SEEK AUDIO PLAYER SLIDER ALONG WITH SONG POSITION DURATION

            ////print("SeekAudioPlayerToEventCALLED ONE $pos");
            if (!isBlocScroll) {
              ////print("SeekAudioPlayerToEventCALLED TWO $pos");
              BlocProvider.of<AudioPlayerBloc>(context).add(
                SeekAudioPlayerToEvent(
                  song: state.queue.elementAt(pos),
                ),
              );
            }
            isBlocScroll = false;

            // if (currentSong.id != state.queue.elementAt(pos).id) {
            //   BlocProvider.of<AudioPlayerBloc>(context).add(
            //     SeekAudioPlayerToEvent(
            //         mediaItem: state.queue.elementAt(pos)),
            //   );
            // }
          },
        );
      },
    ));
  }

  CachedNetworkImage buildCachedNetworkImage(QueueAndIndex state, int index) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: state.queue[index].albumArt.imageLargePath,
      errorWidget: (context, url, error) => buildImagePlaceHolder(),
      placeholder: (context, url) => buildImagePlaceHolder(),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  void initPageControllerPosition() {
    if (BlocProvider.of<AudioPlayerBloc>(context).audioPlayer.sequenceState !=
        null) {
      List<MediaItem> queue = [];
      BlocProvider.of<AudioPlayerBloc>(context)
          .audioPlayer
          .sequenceState!
          .effectiveSequence
          .forEach((mediaItem) {
        queue.add(mediaItem.tag);
      });
      //GET CURRENT PLAYING SONG INDEX FOR THE QUEUE
      MediaItem currentSong = BlocProvider.of<AudioPlayerBloc>(context)
          .audioPlayer
          .sequenceState!
          .currentSource!
          .tag;
      int currentIndex = queue.indexOf(currentSong);
      _pageController = PageController(initialPage: currentIndex);
    } else {
      _pageController = PageController(initialPage: 0);
    }
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
