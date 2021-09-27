import 'dart:async';

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
      : super(LyricInitial()) {
    // subscription = audioPlayerBloc.stream.listen((state) {
    //   if (state is AudioPlayerCurrentSongChangeState) {
    //     ///LOAD LYRIC IF AVAILABLE
    //     if (state.song.lyricIncluded) {
    //       this.add(
    //         LoadSongLyricEvent(songId: state.song.songId),
    //       );
    //     } else {
    //       ///REMOVE LYRIC IF NOT AVAILABLE
    //       this.add(
    //         RemoveLyricWidgetEvent(songId: state.song.songId),
    //       );
    //     }
    //   }
    // });
  }

  //late StreamSubscription subscription;
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

  // @override
  // Future<void> close() {
  //   subscription.cancel();
  //   return super.close();
  // }
}
