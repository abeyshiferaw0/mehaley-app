import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/ui/common/subscribed_tag.dart';
import 'package:mehaley/ui/screens/player/widgets/main_player_controls.dart';
import 'package:mehaley/ui/screens/player/widgets/main_player_top_items.dart';
import 'package:mehaley/ui/screens/player/widgets/mini_lyric_or_quotes_widget.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import 'main_player_album_art_pager.dart';

class MainPlayerWidgets extends StatefulWidget {
  const MainPlayerWidgets();

  @override
  _MainPlayerWidgetsState createState() => _MainPlayerWidgetsState();
}

class _MainPlayerWidgetsState extends State<MainPlayerWidgets>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: ScreenUtil(context: context).getScreenHeight() - 5.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///TOP ITEMS
              SafeArea(
                child: MainPlayerTopItems(),
                bottom: false,
              ),

              ///ACTIVE SUBSCRIPTION TAG
              SubscribedTag(
                color: ColorMapper.getWhite(),
              ),

              ///ALBUM ART PAGER
              MainPlayerAlbumArtPager(),

              ///PLAYER CONTROLS
              MainPlayerControls(),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        ///LYRIC PLAYER OR QUOTES
        MiniLyricOrQuotesWidget(),
      ],
    );
  }
}
