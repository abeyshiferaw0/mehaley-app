import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BgPlayerGradient extends StatefulWidget {
  const BgPlayerGradient({Key? key}) : super(key: key);

  @override
  _BgPlayerGradientState createState() => _BgPlayerGradientState();
}

class _BgPlayerGradientState extends State<BgPlayerGradient> {
  Color dominantColor = AppColors.appGradientDefaultColorBlack;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is PlayerPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          duration:
              Duration(milliseconds: AppValues.colorChangeAnimationDuration),
          child: Container(
            key: ValueKey<int>(state.hashCode),
            width: ScreenUtil(context: context).getScreenWidth(),
            height: ScreenUtil(context: context).getScreenHeight(),
            decoration: BoxDecoration(
              gradient: AppGradients().getPlayerBgGradient(dominantColor),
            ),
          ),
        );
      },
    );
  }
}
