import 'package:elf_play/business_logic/cubits/player_cubits/lyric_parser_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/config/themes.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class LyricPlayerFullPageWidget extends StatefulWidget {
  const LyricPlayerFullPageWidget({required this.dominantColor});

  final Color dominantColor;

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
    return BlocConsumer<LyricParserCubit, List<LyricItem>>(
      listener: (context, lyricList) {
        if (lyricList.length < 1) {
          Navigator.pop(context);
        }
      },
      builder: (context, lyricList) {
        if (lyricList.length > 0) {
          return BlocListener<SongPositionCubit, Duration>(
            listener: (context, duration) {
              //LISTEN TO LYRIC AND DURATION CHANGES
              try {
                if (lyricList.length > 0) {
                  LyricItem lyricItem = lyricList.firstWhere((element) {
                    if (element.startTimeMillisecond >
                        duration.inMilliseconds) {
                      return true;
                    }
                    return false;
                  });
                  if (currentLyricItem != lyricItem) {
                    setState(() {
                      currentLyricItem = lyricItem;
                    });
                  }
                  lyricScrollController.scrollTo(
                    index: lyricItem.index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
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
                itemCount: lyricList.length,
                itemBuilder: (context, index) {
                  return Text(
                    getLyricItemText(lyricList, index),
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
