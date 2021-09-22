import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/blocs/playlist_page_bloc/playlist_page_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/api_response/playlist_page_data.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/menu/playlist_menu_widget.dart';
import 'package:elf_play/ui/screens/playlist/widget/playlist_info_pages.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class PlaylistPageHeader extends StatefulWidget {
  const PlaylistPageHeader({
    required this.shrinkPercentage,
  });

  final double shrinkPercentage;

  @override
  _PlaylistPageHeaderState createState() => _PlaylistPageHeaderState();
}

class _PlaylistPageHeaderState extends State<PlaylistPageHeader> {
  //CONTROLLER FOR PAGE VIEW
  PageController controller = PageController(
    initialPage: 0,
  );

  //DOMINANT COLOR
  Color dominantColor = AppColors.black;

  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is PlaylistPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return BlocBuilder<PlaylistPageBloc, PlaylistPageState>(
          builder: (context, state) {
            return Stack(
              children: [
                AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: Duration(
                    milliseconds: AppValues.colorChangeAnimationDuration,
                  ),
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      gradient: AppGradients()
                          .getPlaylistHeaderGradient(dominantColor),
                    ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          buildAppBar(
                            widget.shrinkPercentage,
                            (state as PlaylistPageLoadedState).playlistPageData,
                          ),
                          Opacity(
                            opacity: 1 - widget.shrinkPercentage,
                            child: buildPlaylistInfo(
                              state.playlistPageData,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //buildPlayShuffleButton()
              ],
            );
          },
        );
      },
    );
  }

  Container buildAppBar(
      double shrinkPercentage, PlaylistPageData playlistPageData) {
    return Container(
      height: 100,
      //color: AppColors.black.withOpacity(shrinkPercentage),
      padding: EdgeInsets.only(top: AppPadding.padding_28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              PhosphorIcons.caret_left_light,
              size: AppIconSizes.icon_size_24,
              color: AppColors.white,
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: shrinkPercentage,
              child: Text(
                playlistPageData.playlist.playlistNameText.textAm,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          AppBouncingButton(
            child: Icon(
              PhosphorIcons.dots_three_vertical_bold,
              size: AppIconSizes.icon_size_28,
              color: AppColors.lightGrey,
            ),
            onTap: () {
              PagesUtilFunctions.showMenuDialog(
                context: context,
                child: PlaylistMenuWidget(
                  title: playlistPageData.playlist.playlistNameText.textAm,
                  imageUrl: AppApi.baseFileUrl +
                      playlistPageData.playlist.playlistImage.imageMediumPath,
                  isFree: playlistPageData.playlist.isFree,
                  price: playlistPageData.playlist.priceEtb,
                  isDiscountAvailable:
                      playlistPageData.playlist.isDiscountAvailable,
                  discountPercentage:
                      playlistPageData.playlist.discountPercentage,
                  playlistId: playlistPageData.playlist.playlistId,
                  isFollowed: playlistPageData.playlist.isFollowed!,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildPlaylistInfo(PlaylistPageData playlistPageData) {
    return Transform.translate(
      //scale: (1 - widget.shrinkPercentage),
      //angle: (1 - widget.shrinkPercentage),
      offset: Offset(0, (widget.shrinkPercentage) * 30),
      child: Container(
        height: 400,
        //color: Colors.green,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    pageNotifier.value = index;
                  });
                },
                children: [
                  PlaylistInfoPageOne(playlistPageData: playlistPageData),
                  PlaylistInfoPageTwo(playlistPageData: playlistPageData),
                ],
              ),
            ),
            CirclePageIndicator(
              dotColor: AppColors.grey,
              selectedDotColor: AppColors.white,
              currentPageNotifier: pageNotifier,
              size: 6,
              itemCount: 2,
            ),
            SizedBox(height: AppMargin.margin_12),
          ],
        ),
      ),
    );
  }
}
