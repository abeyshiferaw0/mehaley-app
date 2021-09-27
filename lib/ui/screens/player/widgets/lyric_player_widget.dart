import 'package:elf_play/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/screens/player/lyric_full_page.dart';
import 'package:elf_play/ui/screens/player/widgets/share_btn_widget.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

class LyricPlayerWidget extends StatefulWidget {
  const LyricPlayerWidget({required this.song});

  final Song song;

  @override
  _LyricPlayerWidgetState createState() => _LyricPlayerWidgetState();
}

class _LyricPlayerWidgetState extends State<LyricPlayerWidget> {
  //SCROLLER CONTROLLER AND LISTENER
  final ItemScrollController lyricScrollController = ItemScrollController();
  final ItemPositionsListener lyricPositionsListener =
      ItemPositionsListener.create();

  _LyricPlayerWidgetState();

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColor;

  //CURRENT LYRIC ITEM
  LyricItem? currentLyricItem;

  @override
  void initState() {
    BlocProvider.of<LyricBloc>(context).add(
      LoadSongLyricEvent(songId: widget.song.songId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PagesUtilFunctions.createBottomToUpAnimatedRoute(
            page: BlocProvider.value(
              value: BlocProvider.of<LyricBloc>(context),
              child: LyricFullPage(
                song: widget.song,
              ),
            ),
          ),
        );
      },
      child: BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
        builder: (context, state) {
          if (state is PlayerPageDominantColorChangedState) {
            dominantColor = ColorUtil.changeColorSaturation(state.color, 0.9);
          }
          return BlocBuilder<LyricBloc, LyricState>(
            builder: (context, state) {
              if (state is LyricDataLoaded) {
                if (state.lyricList.length > 0 &&
                    state.songId == widget.song.songId) {
                  return BlocListener<SongPositionCubit, Duration>(
                      listener: (context, duration) {
                        //LISTEN TO LYRIC AND DURATION CHANGES
                        try {
                          if (state.lyricList.length > 0) {
                            LyricItem lyricItem =
                                state.lyricList.firstWhere((element) {
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
                      child: Container(
                        height: AppValues.lyricPlayerHeight,
                        padding: EdgeInsets.all(AppPadding.padding_14),
                        margin: EdgeInsets.all(AppMargin.margin_16),
                        decoration: BoxDecoration(
                          color: dominantColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LYRICS",
                              style: TextStyle(
                                fontSize: AppFontSizes.font_size_10.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(
                              height: AppMargin.margin_28,
                            ),
                            Expanded(
                              child: ScrollablePositionedList.builder(
                                physics: NeverScrollableScrollPhysics(),
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
                                              : AppColors.black
                                                  .withOpacity(0.7))
                                          : AppColors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                                itemScrollController: lyricScrollController,
                                itemPositionsListener: lyricPositionsListener,
                              ),
                            ),
                            SizedBox(
                              height: AppMargin.margin_16,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ShareBtnWidget(),
                            )
                          ],
                        ),
                      ));
                } else {
                  return SizedBox();
                }
              }
              return SizedBox();
            },
          );
        },
      ),
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
