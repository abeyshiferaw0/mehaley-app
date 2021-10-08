import 'package:elf_play/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/menu/song_menu_widget.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
        top: AppMargin.margin_32,
        //left: AppMargin.margin_16,
        //right: AppMargin.margin_16,
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
              PhosphorIcons.caret_down_light,
              color: AppColors.white,
              size: AppIconSizes.icon_size_24,
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
                      color: AppColors.lightGrey,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    state.title,
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_8.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<CurrentPlayingCubit, Song?>(
            builder: (context, state) {
              return AppBouncingButton(
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.padding_8),
                  child: Icon(
                    PhosphorIcons.dots_three_vertical_bold,
                    color: AppColors.white,
                    size: AppIconSizes.icon_size_24,
                  ),
                ),
                onTap: () {
                  //SHOW MENU DIALOG
                  PagesUtilFunctions.showMenuDialog(
                    context: context,
                    child: SongMenuWidget(
                      song: state!,
                      isForMyPlaylist: false,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
