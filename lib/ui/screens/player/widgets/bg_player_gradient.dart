import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/screen_util.dart';

class BgPlayerGradient extends StatefulWidget {
  const BgPlayerGradient({Key? key}) : super(key: key);

  @override
  _BgPlayerGradientState createState() => _BgPlayerGradientState();
}

class _BgPlayerGradientState extends State<BgPlayerGradient> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, state) {
        if (state != null) {
          return AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            duration: Duration(
              milliseconds: AppValues.colorChangeAnimationDuration,
            ),
            child: Container(
              key: ValueKey<int>(state.hashCode),
              width: ScreenUtil(context: context).getScreenWidth(),
              height: ScreenUtil(context: context).getScreenHeight(),
              decoration: BoxDecoration(
                gradient: AppGradients().getPlayerBgGradient(
                  HexColor(state.albumArt.primaryColorHex),
                ),
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
