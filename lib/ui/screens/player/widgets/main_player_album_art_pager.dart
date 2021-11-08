import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/player_queue_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';

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
        return GestureDetector(
          onHorizontalDragEnd: (dragDetails) {},
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: state.queue.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: AppCard(
                  radius: 0.0,
                  constraints: BoxConstraints(
                    maxHeight:
                        ScreenUtil(context: context).getScreenWidth() * 0.8,
                    minHeight:
                        ScreenUtil(context: context).getScreenWidth() * 0.7,
                    maxWidth:
                        ScreenUtil(context: context).getScreenWidth() * 0.95,
                    minWidth:
                        ScreenUtil(context: context).getScreenWidth() * 0.8,
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: AppApi.baseUrl +
                        state.queue[index].albumArt.imageMediumPath,
                    errorWidget: (context, url, error) =>
                        buildImagePlaceHolder(),
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
                  ),
                ),
              );
            },
            onPageChanged: (pos) {
              // //SEEK AUDIO PLAYER SLIDER ALONG WITH SONG POSITION DURATION

              if (!isBlocScroll) {
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
          ),
        );
      },
    ));
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
