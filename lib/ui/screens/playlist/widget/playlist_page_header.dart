import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/playlist_page_data.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/menu/playlist_menu_widget.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/ui/screens/playlist/widget/playlist_info_pages.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class PlaylistPageHeader extends StatefulWidget {
  const PlaylistPageHeader({
    required this.shrinkPercentage,
    required this.playlistPageData,
    required this.height,
    required this.appBarHeight,
  });

  final double shrinkPercentage;
  final PlaylistPageData playlistPageData;
  final double height;
  final double appBarHeight;

  @override
  _PlaylistPageHeaderState createState() => _PlaylistPageHeaderState();
}

class _PlaylistPageHeaderState extends State<PlaylistPageHeader> {
  //CONTROLLER FOR PAGE VIEW
  PageController controller = PageController(
    initialPage: 0,
  );

  //DOMINANT COLOR
  Color dominantColor = ColorMapper.getWhite();

  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is PlaylistPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return Stack(
          children: [
            Container(
              height: widget.height,
              color: ColorMapper.getWhite(),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    buildAppBar(
                      widget.shrinkPercentage,
                      widget.playlistPageData,
                    ),
                    SizedBox(height: AppMargin.margin_12),
                    Opacity(
                      opacity: 1 - widget.shrinkPercentage,
                      child: buildPlaylistInfo(
                        widget.playlistPageData,
                      ),
                    )
                  ],
                ),
              ),
            ),
            //buildPlayShuffleButton()
          ],
        );
      },
    );
  }

  Container buildAppBar(
    double shrinkPercentage,
    PlaylistPageData playlistPageData,
  ) {
    return Container(
      height: widget.appBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FlutterRemix.arrow_left_line,
              size: AppIconSizes.icon_size_24,
              color: ColorMapper.getBlack(),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Opacity(
                  opacity: shrinkPercentage,
                  child: Center(
                    child: Text(
                      L10nUtil.translateLocale(
                          playlistPageData.playlist.playlistNameText, context),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: AppFontSizes.font_size_16,
                        fontWeight: FontWeight.w600,
                        color: ColorMapper.getBlack(),
                      ),
                    ),
                  ),
                ),
                playlistPageData.playlist.isBought
                    ? Opacity(
                        opacity: 1 - shrinkPercentage,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppPadding.padding_4,
                            ),
                            child: SmallTextPriceWidget(
                              priceEtb: playlistPageData.playlist.priceEtb,
                              priceUsd: playlistPageData.playlist.priceDollar,
                              isFree: playlistPageData.playlist.isFree,
                              useLargerText: true,
                              isDiscountAvailable:
                                  playlistPageData.playlist.isDiscountAvailable,
                              discountPercentage:
                                  playlistPageData.playlist.discountPercentage,
                              isPurchased: playlistPageData.playlist.isBought,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          AppBouncingButton(
            child: Icon(
              FlutterRemix.more_2_fill,
              size: AppIconSizes.icon_size_28,
              color: ColorMapper.getDarkGrey(),
            ),
            onTap: () {
              PagesUtilFunctions.showMenuSheet(
                context: context,
                child: PlaylistMenuWidget(
                  playlist: playlistPageData.playlist,
                  onBuyButtonClicked: () {
                    PurchaseUtil.playlistMenuBuyButtonOnClick(
                      context,
                      playlistPageData.playlist,
                      true,
                    );
                  },
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
      offset: Offset(0, (widget.shrinkPercentage) * -60),
      child: Container(
        height: AppValues.playlistHeaderSliverSize -
            AppValues.playlistHeaderAppBarSliverSize,
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
                  PlaylistInfoPageOne(
                    playlistPageData: widget.playlistPageData,
                  ),
                  PlaylistInfoPageTwo(
                    songs: widget.playlistPageData.songs,
                    playlist: widget.playlistPageData.playlist,
                  ),
                  PlaylistInfoPageThree(
                    songs: widget.playlistPageData.songs,
                    playlist: widget.playlistPageData.playlist,
                  ),
                ],
              ),
            ),
            CirclePageIndicator(
              dotColor: ColorMapper.getDarkGrey(),
              selectedDotColor: ColorMapper.getBlack(),
              currentPageNotifier: pageNotifier,
              size: AppIconSizes.icon_size_6,
              itemCount: 3,
            ),
            SizedBox(height: AppMargin.margin_16),
          ],
        ),
      ),
    );
  }
}
