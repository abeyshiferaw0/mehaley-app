import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_page_bloc/user_playlist_page_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/menu/user_playlist_menu_widget.dart';
import 'package:mehaley/ui/screens/user_playlist/widget/user_playlist_info_pages.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class UserPlaylistPageHeader extends StatefulWidget {
  const UserPlaylistPageHeader({
    required this.shrinkPercentage,
    required this.songs,
    required this.myPlaylist,
  });

  final double shrinkPercentage;
  final List<Song> songs;
  final MyPlaylist myPlaylist;

  @override
  _UserPlaylistPageHeaderState createState() => _UserPlaylistPageHeaderState();
}

class _UserPlaylistPageHeaderState extends State<UserPlaylistPageHeader> {
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
        if (state is UserPlaylistPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return Container(
          height: AppValues.userPlaylistHeaderSliverHeight,
          color: ColorMapper.getWhite(),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                buildAppBar(
                  widget.shrinkPercentage,
                  widget.myPlaylist,
                ),
                Opacity(
                  opacity: 1 - widget.shrinkPercentage,
                  child: buildUserPlaylistInfo(
                    widget.myPlaylist,
                    widget.songs,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Container buildAppBar(double shrinkPercentage, MyPlaylist myPlaylist) {
    return Container(
      height: AppValues.userPlaylistHeaderAppBarSliverHeight,
      //color: ColorMapper.getBlack().withOpacity(shrinkPercentage),
      padding: EdgeInsets.only(top: AppPadding.padding_28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            child: Opacity(
              opacity: shrinkPercentage,
              child: Text(
                L10nUtil.translateLocale(myPlaylist.playlistNameText, context),
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
          AppBouncingButton(
            child: Icon(
              FlutterRemix.more_2_fill,
              size: AppIconSizes.icon_size_28,
              color: ColorMapper.getDarkGrey(),
            ),
            onTap: () {
              PagesUtilFunctions.showMenuSheet(
                context: context,
                child: UserPlaylistMenuWidget(
                  myPlaylist: myPlaylist,
                  title: L10nUtil.translateLocale(
                      myPlaylist.playlistNameText, context),
                  imageUrl: '',
                  isFree: myPlaylist.isFree,
                  price: myPlaylist.priceEtb,
                  isDiscountAvailable: myPlaylist.isDiscountAvailable,
                  discountPercentage: myPlaylist.discountPercentage,
                  playlistId: myPlaylist.playlistId,
                  isFollowed: myPlaylist.isFollowed!,
                  onUpdateSuccess: (myPlaylist) {
                    BlocProvider.of<UserPlaylistPageBloc>(context).add(
                      RefreshUserPlaylistPageEvent(
                        myPlaylist: myPlaylist,
                        songs: widget.songs,
                      ),
                    );
                  },
                  onPlaylistDelete: (MyPlaylist myPlaylist) {
                    BlocProvider.of<UserPlaylistBloc>(context).add(
                      DeletePlaylistEvent(
                        myPlaylist: myPlaylist,
                      ),
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

  Widget buildUserPlaylistInfo(MyPlaylist myPlaylist, List<Song> songs) {
    return Transform.translate(
      //scale: (1 - widget.shrinkPercentage),
      //angle: (1 - widget.shrinkPercentage),
      offset: Offset(0, (widget.shrinkPercentage) * -50),
      child: Container(
        height: AppValues.userPlaylistHeaderSliverHeight -
            AppValues.userPlaylistHeaderAppBarSliverHeight,
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
                  UserPlaylistInfoPageOne(
                    myPlaylist: myPlaylist,
                  ),
                  UserPlaylistInfoPageTwo(
                    myPlaylist: myPlaylist,
                    songs: songs,
                  ),
                ],
              ),
            ),
            CirclePageIndicator(
              dotColor: ColorMapper.getDarkGrey(),
              selectedDotColor: ColorMapper.getBlack(),
              currentPageNotifier: pageNotifier,
              size: AppIconSizes.icon_size_6,
              itemCount: 2,
            ),
            SizedBox(
              height: AppMargin.margin_12,
            ),
          ],
        ),
      ),
    );
  }
}
