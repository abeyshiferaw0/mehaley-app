import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/menu/song_menu_widget.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:sizer/sizer.dart';

class MainPlayerTopItems extends StatefulWidget {
  const MainPlayerTopItems({Key? key}) : super(key: key);

  @override
  _MainPlayerTopItemsState createState() => _MainPlayerTopItemsState();
}

class _MainPlayerTopItemsState extends State<MainPlayerTopItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 0.6.h,
        bottom: 0.6.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FlutterRemix.arrow_down_s_line,
              color: ColorMapper.getWhite(),
              size: AppIconSizes.icon_size_28,
            ),
          ),
          BlocBuilder<PlayerPagePlayingFromCubit, PlayingFrom>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    state.from.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_6.sp,
                      color: ColorMapper.getLightGrey(),
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(
                    height: AppMargin.margin_4,
                  ),
                  Text(
                    state.title,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorMapper.getWhite(),
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<CurrentPlayingCubit, Song?>(
            builder: (context, state) {
              if (state != null) {
                return AppBouncingButton(
                  child: Padding(
                    padding: EdgeInsets.all(AppPadding.padding_8),
                    child: Icon(
                      FlutterRemix.more_2_fill,
                      color: ColorMapper.getWhite(),
                      size: AppIconSizes.icon_size_24,
                    ),
                  ),
                  onTap: () {
                    //SHOW MENU DIALOG
                    PagesUtilFunctions.showMenuSheet(
                      context: context,
                      child: SongMenuWidget(
                        song: state,
                        isForMyPlaylist: false,
                        onCreateWithSongSuccess: (MyPlaylist myPlaylist) {},
                        onSubscribeButtonClicked: () {
                          ///GO TO SUBSCRIPTION PAGE
                          Navigator.pushNamed(
                            context,
                            AppRouterPaths.subscriptionRoute,
                          );
                        },
                        onSongBuyClicked: () {
                          PurchaseUtil.songMenuBuyButtonOnClick(context, state);
                        },
                      ),
                    );
                  },
                );
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
