import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/screens/player/widgets/main_player_controls.dart';
import 'package:mehaley/ui/screens/player/widgets/main_player_top_items.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

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
              AppMargin.margin_52.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///TOP ITEMS
              MainPlayerTopItems(),

              ///ALBUM ART PAGER
              MainPlayerAlbumArtPager(),

              ///PLAYER CONTROLS
              MainPlayerControls(),
            ],
          ),
        ),
        SizedBox(height: AppMargin.margin_8),

        ///LYRIC PLAYER
        BlocProvider<LyricBloc>(
          create: (context) => LyricBloc(
            audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
            lyricDataRepository: AppRepositories.lyricDataRepository,
          ),
          child: LyricPlayerWidget(),
        ),
      ],
    );
  }
}
