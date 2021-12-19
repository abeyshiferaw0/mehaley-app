import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mehaley/business_logic/blocs/lyric_bloc/lyric_bloc.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/data/models/song.dart';

import 'daily_quotes_widget.dart';
import 'mini_lyric_player_widget.dart';

class MiniLyricOrQuotesWidget extends StatelessWidget {
  const MiniLyricOrQuotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, state) {
        if (state != null) {
          if (state.lyricIncluded) {
            return BlocProvider<LyricBloc>(
              create: (context) => LyricBloc(
                audioPlayerBloc: BlocProvider.of<AudioPlayerBloc>(context),
                lyricDataRepository: AppRepositories.lyricDataRepository,
              ),
              child: MiniLyricPlayerWidget(
                song: state,
              ),
            );
          } else {
            return DailyQuotesWidget(
              dominantColor: HexColor(
                state.albumArt.primaryColorHex,
              ),
            );
          }
        }
        return SizedBox();
      },
    );
  }
}
