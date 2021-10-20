import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/lyric_item.dart';
import 'package:elf_play/data/repositories/lyric_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'lyric_event.dart';
part 'lyric_state.dart';

class LyricBloc extends Bloc<LyricEvent, LyricState> {
  LyricBloc({required this.lyricDataRepository, required this.audioPlayerBloc})
      : super(LyricInitial());

  final AudioPlayerBloc audioPlayerBloc;
  final LyricDataRepository lyricDataRepository;

  @override
  Stream<LyricState> mapEventToState(
    LyricEvent event,
  ) async* {
    if (event is LoadSongLyricEvent) {
      //LOAD CACHE AND REFRESH
      yield LyricDataLoading();
      try {
        //YIELD CACHE DATA
        final List<LyricItem> lyricList =
            await lyricDataRepository.getLyricData(
          event.songId,
          AppCacheStrategy.LOAD_CACHE_FIRST,
          event.currentLocale,
        );
        yield LyricDataLoaded(lyricList: lyricList, songId: event.songId);
        try {
          //REFRESH AFTER CACHE YIELD
          final List<LyricItem> lyricList =
              await lyricDataRepository.getLyricData(
            event.songId,
            AppCacheStrategy.CACHE_LATER,
            event.currentLocale,
          );
          yield LyricDataLoading();
          yield LyricDataLoaded(lyricList: lyricList, songId: event.songId);
        } catch (error) {
          //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
        }
      } catch (error) {
        if (error is DioError) {
          if (CancelToken.isCancel(error)) {
            print('Request canceled! ' + error.message);
          } else {
            yield LyricDataLoadingError(error: error.toString());
          }
        }
        yield LyricDataLoadingError(error: error.toString());
      }
    } else if (event is RemoveLyricWidgetEvent) {
      yield LyricDataLoaded(lyricList: [], songId: event.songId);
    }
  }
}
