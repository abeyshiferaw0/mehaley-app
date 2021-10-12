import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:elf_play/business_logic/blocs/user_playlist_page_bloc/user_playlist_page_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/menu/user_playlist_menu_widget.dart';
import 'package:elf_play/ui/screens/user_playlist/widget/user_playlist_info_pages.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
  Color dominantColor = AppColors.black;

  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is UserPlaylistPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return Stack(
          children: [
            AnimatedSwitcher(
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              duration: Duration(
                milliseconds: AppValues.colorChangeAnimationDuration,
              ),
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  gradient: AppGradients()
                      .getUserPlaylistHeaderGradient(dominantColor),
                ),
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
              ),
            ),
            //buildPlayShuffleButton()
          ],
        );
      },
    );
  }

  Container buildAppBar(double shrinkPercentage, MyPlaylist myPlaylist) {
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
                myPlaylist.playlistNameText.textAm,
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
                child: UserPlaylistMenuWidget(
                  myPlaylist: myPlaylist,
                  title: myPlaylist.playlistNameText.textAm,
                  imageUrl: "",
                  isFree: myPlaylist.isFree,
                  price: myPlaylist.priceEtb,
                  isDiscountAvailable: myPlaylist.isDiscountAvailable,
                  discountPercentage: myPlaylist.discountPercentage,
                  playlistId: myPlaylist.playlistId,
                  isFollowed: myPlaylist.isFollowed!,
                  onUpdateSuccess: (myPlaylist) {
                    print(
                        "onUpdateSuccess 2 ${myPlaylist.playlistNameText.textAm}");
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
      offset: Offset(0, (widget.shrinkPercentage) * 30),
      child: Container(
        height: 350,
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
