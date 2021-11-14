import 'package:elf_play/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';import 'package:elf_play/app_language/app_locale.dart';

class LyricPlayerFullPageWidget extends StatefulWidget {
  const LyricPlayerFullPageWidget(
      {required this.dominantColor, required this.song});

  final Color dominantColor;
  final Song song;

  @override
  _LyricPlayerFullPageWidgetState createState() =>
      _LyricPlayerFullPageWidgetState();
}

class _LyricPlayerFullPageWidgetState extends State<LyricPlayerFullPageWidget> {
  //SCROLLER CONTROLLER AND LISTENER
  final ItemScrollController lyricScrollController = ItemScrollController();
  final ItemPositionsListener lyricPositionsListener =
      ItemPositionsListener.create();

  _LyricPlayerFullPageWidgetState();

  //CURRENT LYRIC ITEM
  LyricItem? currentLyricItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LyricBloc, LyricState>(
      listener: (context, state) {
        if (state is LyricDataLoaded) {
          if (state.lyricList.length < 1 ||
              state.songId != widget.song.songId) {
            Navigator.pop(context);
          }
        }
      },
      builder: (context, state) {
        if (state is LyricDataLoaded) {
          if (state.lyricList.length > 0 &&
              state.songId == widget.song.songId) {
            return BlocListener<SongPositionCubit, CurrentPlayingPosition>(
              listener: (context, duration) {
                //LISTEN TO LYRIC AND DURATION CHANGES
                try {
                  if (state.lyricList.length > 0) {
                    LyricItem lyricItem = state.lyricList.firstWhere((element) {
                      if (element.startTimeMillisecond >
                          duration.currentDuration.inMilliseconds) {
                        return true;
                      }
                      return false;
                    });
                    if (currentLyricItem != lyricItem) {
                      setState(() {
                        currentLyricItem = lyricItem;
                      });
                    }
                    if (state.lyricList.length > lyricItem.index) {
                      lyricScrollController.scrollTo(
                        index: lyricItem.index,
                        duration: Duration(milliseconds: 0),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                } catch (e) {}
                //LISTEN TO LYRIC AND DURATION CHANGES
              },
              child: ShaderMask(
                blendMode: BlendMode.dstOut,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.dominantColor,
                      Colors.transparent,
                      Colors.transparent,
                      widget.dominantColor,
                    ],
                    stops: [0.0, 0.05, 0.95, 1.0],
                  ).createShader(bounds);
                },
                child: ScrollablePositionedList.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.lyricList.length,
                  itemBuilder: (context, index) {
                    return Text(
                      getLyricItemText(state.lyricList, index),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_16.sp,
                        color: currentLyricItem != null
                            ? (currentLyricItem!.index == index
                                ? AppColors.white
                                : AppColors.black.withOpacity(0.7))
                            : AppColors.black.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                  itemScrollController: lyricScrollController,
                  itemPositionsListener: lyricPositionsListener,
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        }
        return SizedBox();
      },
    );
  }

  String getLyricItemText(List<LyricItem> lyricList, int index) {
    if (lyricList.isNotEmpty) {
      if (index < lyricList.length) {
        return lyricList[index].content;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }
}
