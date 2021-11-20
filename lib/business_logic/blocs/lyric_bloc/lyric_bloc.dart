import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/business_logic/blocs/player_page_bloc/audio_player_bloc.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/lyric_item.dart';
import 'package:mehaley/data/repositories/lyric_data_repository.dart';

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
      lyricDataRepository.cancelDio();
      yield LyricDataLoading();
      try {
        //YIELD CACHE DATA
        final List<LyricItem> lyricList =
            await lyricDataRepository.getLyricData(
          event.songId,
          AppCacheStrategy.LOAD_CACHE_FIRST,
        );
        yield LyricDataLoaded(lyricList: lyricList, songId: event.songId);
        try {
          //REFRESH AFTER CACHE YIELD
          final List<LyricItem> lyricList =
              await lyricDataRepository.getLyricData(
            event.songId,
            AppCacheStrategy.CACHE_LATER,
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
