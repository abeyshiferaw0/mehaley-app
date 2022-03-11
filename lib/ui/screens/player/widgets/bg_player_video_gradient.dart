import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mehaley/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/util/screen_util.dart';

class BgPlayerVideoGradient extends StatelessWidget {
  Color dominantColor = ColorMapper.getWhite();

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
