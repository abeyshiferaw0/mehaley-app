import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/song_position_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/lyric_item.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/screens/player/lyric_full_page.dart';
import 'package:mehaley/ui/screens/player/widgets/share_btn_widget.dart';
import 'package:mehaley/ui/screens/player/widgets/shimmer_lyric.dart';
import 'package:mehaley/util/color_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';

class MiniLyricPlayerWidget extends StatefulWidget {
  final Song song;

  const MiniLyricPlayerWidget({Key? key, required this.song}) : super(key: key);

  @override
  _MiniLyricPlayerWidgetState createState() => _MiniLyricPlayerWidgetState();
}

class _MiniLyricPlayerWidgetState extends State<MiniLyricPlayerWidget> {
  //SCROLLER CONTROLLER AND LISTENER
  final ItemScrollController lyricScrollController = ItemScrollController();
  final ItemPositionsListener lyricPositionsListener =
      ItemPositionsListener.create();

  _MiniLyricPlayerWidgetState();

  //CURRENT LYRIC ITEM
  LyricItem? currentLyricItem;

  @override
  void initState() {
    BlocProvider.of<LyricBloc>(context).add(
      LoadSongLyricEvent(
        songId: widget.song.songId,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LyricBloc, LyricState>(
      builder: (context, state) {
        if (state is LyricDataLoaded) {
          if (state.lyricList.length > 0) {
            return buildLyricLoaded(context, state, widget.song);
          } else {
            return SizedBox();
          }
        }
        if (state is LyricDataLoadingError) {
          return buildLyricLoadingError(widget.song);
        }
        if (state is LyricDataLoading) {
          return ShimmerLyric(
            dominantColor: HexColor(
              widget.song.albumArt.primaryColorHex,
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  GestureDetector buildLyricLoaded(
      BuildContext context, LyricDataLoaded lyricData, Song song) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PagesUtilFunctions.createBottomToUpAnimatedRoute(
              page: BlocProvider.value(
                value: BlocProvider.of<LyricBloc>(context),
                child: LyricFullPage(
                  isForSharing: false,
                  song: song,
                  dominantColor: HexColor(
                    song.albumArt.primaryColorHex,
                  ),
                ),
              ),
            ),
          );
        },
        child: BlocListener<SongPositionCubit, CurrentPlayingPosition>(
            listener: (context, duration) {
              //LISTEN TO LYRIC AND DURATION CHANGES
              try {
                if (lyricData.lyricList.length > 0) {
                  LyricItem lyricItem =
                      lyricData.lyricList.firstWhere((element) {
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
                  lyricScrollController.scrollTo(
                    index: lyricItem.index,
                    duration: Duration(milliseconds: 0),
                    curve: Curves.easeIn,
                  );
                }
              } catch (e) {}
              //LISTEN TO LYRIC AND DURATION CHANGES
            },
            child: Container(
              height: AppValues.lyricPlayerHeight,
              padding: EdgeInsets.only(
                left: AppPadding.padding_14,
                right: AppPadding.padding_14,
                bottom: AppPadding.padding_14,
                top: AppPadding.padding_8,
              ),
              decoration: BoxDecoration(
                color: ColorMapper.getWhite(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocale.of().lyrics.toUpperCase(),
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_10.sp,
                          color: ColorMapper.getBlack(),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      AppBouncingButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            PagesUtilFunctions.createBottomToUpAnimatedRoute(
                              page: BlocProvider.value(
                                value: BlocProvider.of<LyricBloc>(context),
                                child: LyricFullPage(
                                  song: song,
                                  dominantColor: HexColor(
                                    song.albumArt.primaryColorHex,
                                  ),
                                  isForSharing: false,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.padding_14,
                            vertical: AppPadding.padding_4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorMapper.getBlack().withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocale.of().expand.toUpperCase(),
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_6.sp,
                                  color: ColorMapper.getWhite(),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(width: AppMargin.margin_8),
                              Icon(
                                FlutterRemix.zoom_out_line,
                                size: AppIconSizes.icon_size_16 - 3,
                                color: ColorMapper.getWhite(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppMargin.margin_8),
                  Divider(
                    color: ColorMapper.getLightGrey(),
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Expanded(
                    child: ShaderMask(
                      blendMode: BlendMode.dstOut,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorMapper.getWhite(),
                            Colors.transparent,
                            Colors.transparent,
                            ColorMapper.getWhite(),
                          ],
                          stops: [0.0, 0.05, 0.95, 1.0],
                        ).createShader(bounds);
                      },
                      child: ScrollablePositionedList.builder(
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: lyricData.lyricList.length,
                        itemBuilder: (context, index) {
                          return Text(
                            getLyricItemText(lyricData.lyricList, index),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: AppFontSizes.font_size_16.sp,
                              color: currentLyricItem != null
                                  ? (currentLyricItem!.index == index
                                      ? ColorUtil.changeColorSaturation(
                                          HexColor(
                                            song.albumArt.primaryColorHex,
                                          ),
                                          0.8,
                                        )
                                      : ColorMapper.getBlack())
                                  : ColorMapper.getBlack(),
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                        itemScrollController: lyricScrollController,
                        itemPositionsListener: lyricPositionsListener,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ShareBtnWidget(
                      color: ColorMapper.getBlack(),
                      onTap: () {
                        Navigator.push(
                          context,
                          PagesUtilFunctions.createBottomToUpAnimatedRoute(
                            page: BlocProvider.value(
                              value: BlocProvider.of<LyricBloc>(context),
                              child: LyricFullPage(
                                isForSharing: true,
                                song: song,
                                dominantColor: HexColor(
                                  song.albumArt.primaryColorHex,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )));
  }

  Container buildLyricLoadingError(Song song) {
    return Container(
      height: AppValues.lyricPlayerHeight,
      decoration: BoxDecoration(
        color: ColorMapper.getWhite(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(AppPadding.padding_14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.of().lyrics.toUpperCase(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10.sp,
              color: ColorMapper.getBlack(),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          Divider(
            color: ColorMapper.getLightGrey(),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocale.of().cantLoadLyrics,
                    style: TextStyle(
                      color: ColorMapper.getBlack(),
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.font_size_12.sp,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_8,
                  ),
                  Text(
                    AppLocale.of().checkYourInternetConnection.toUpperCase(),
                    style: TextStyle(
                      color: ColorMapper.getDarkGrey(),
                      fontSize: AppFontSizes.font_size_10.sp,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_16,
                  ),
                  AppBouncingButton(
                    onTap: () {
                      BlocProvider.of<LyricBloc>(context).add(
                        LoadSongLyricEvent(
                          songId: song.songId,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.padding_32,
                        vertical: AppPadding.padding_8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorMapper.getBlack(),
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: Text(
                        AppLocale.of().tryAgain.toUpperCase(),
                        style: TextStyle(
                          color: ColorMapper.getWhite(),
                          fontWeight: FontWeight.w600,
                          fontSize: AppFontSizes.font_size_10.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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
