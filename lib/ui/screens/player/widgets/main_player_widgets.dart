import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/player/widgets/main_player_controls.dart';
import 'package:elf_play/ui/screens/player/widgets/main_player_top_items.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'lyric_player_widget.dart';
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
          height: ScreenUtil(context: context).getScreenHeight() -
              AppMargin.margin_62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TOP ITEMS
              MainPlayerTopItems(),
              //ALBUM ART PAGER
              MainPlayerAlbumArtPager(),
              //PLAYER CONTROLS
              MainPlayerControls(),
            ],
          ),
        ),
        SizedBox(height: AppMargin.margin_8),
        LyricPlayerWidget(),
        //DailyQuotesWidget(dominantColor: AppColors.appGradientDefaultColor)
      ],
    );
  }
}
