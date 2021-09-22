import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BgPlayerVideoGradient extends StatelessWidget {
  Color dominantColor = AppColors.completelyBlack;

  BgPlayerVideoGradient();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is PlayerPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return Container(
          width: ScreenUtil(context: context).getScreenWidth(),
          height: ScreenUtil(context: context).getScreenHeight(),
          decoration: BoxDecoration(
            gradient: AppGradients().getPlayerVideoBgGradient(dominantColor),
          ),
        );
      },
    );
  }
}
