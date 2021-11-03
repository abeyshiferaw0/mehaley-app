import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeaderGradient extends StatefulWidget {
  @override
  State<HomeHeaderGradient> createState() => _HomeHeaderGradientState();
}

class _HomeHeaderGradientState extends State<HomeHeaderGradient> {
  Color dominantColor = AppColors.blue2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is HomePageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return Container(
          height: AppValues.homeHeaderGradientColor,
          decoration: BoxDecoration(
            gradient: AppGradients().getHomeHeaderGradient(dominantColor),
          ),
        );
      },
    );
  }
}
