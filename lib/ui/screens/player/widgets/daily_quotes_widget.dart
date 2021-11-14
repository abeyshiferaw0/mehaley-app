import 'package:elf_play/app_language/app_locale.dart';
import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:sizer/sizer.dart';

class DailyQuotesWidget extends StatefulWidget {
  final Color dominantColor;

  const DailyQuotesWidget({required this.dominantColor});

  @override
  _DailyQuotesWidgetState createState() => _DailyQuotesWidgetState();
}

class _DailyQuotesWidgetState extends State<DailyQuotesWidget> {
  late final _currentPageNotifier;
  late PageController _pageController;

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColor;

  @override
  void initState() {
    _currentPageNotifier = ValueNotifier<int>(0);
    _pageController = PageController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      BlocProvider.of<QuotesBloc>(context).add(
        LoadRandomQuotesEvent(
          limit: 5,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is PlayerPageDominantColorChangedState) {
          dominantColor = ColorUtil.changeColorSaturation(state.color, 0.9);
        }
        return BlocBuilder<QuotesBloc, QuotesState>(
          builder: (context, state) {
            if (state is QuotesLoadedState) {
              return Container(
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
                      AppLocale.of().dailyQuotesFromApp.toUpperCase(),
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
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: state.verseList.length,
                        onPageChanged: (index) {
                          _currentPageNotifier.value = index;
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.verseList.elementAt(index).verse,
                                textAlign: TextAlign.left,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_16.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: AppMargin.margin_16,
                              ),
                              Text(
                                state.verseList.elementAt(index).reference,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: AppFontSizes.font_size_14.sp,
                                  color: AppColors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    buildIndicators(state.verseList),
                  ],
                ),
              );
            }
            return SizedBox();
          },
        );
      },
    );
  }

  Padding buildIndicators(versesList) {
    return Padding(
      padding: EdgeInsets.only(left: AppMargin.margin_16),
      child: CirclePageIndicator(
        itemCount: versesList.length,
        size: AppIconSizes.icon_size_10,
        selectedSize: AppIconSizes.icon_size_12,
        selectedDotColor: AppColors.black.withOpacity(0.6),
        dotColor: AppColors.lightGrey,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
