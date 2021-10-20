import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/playlist_page_data.dart';
import 'package:elf_play/data/repositories/playlist_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'playlist_page_event.dart';
part 'playlist_page_state.dart';

class PlaylistPageBloc extends Bloc<PlaylistPageEvent, PlaylistPageState> {
  PlaylistPageBloc({required this.playlistDataRepository})
      : super(PlaylistPageInitial());

  final PlaylistDataRepository playlistDataRepository;

  @override
  Stream<PlaylistPageState> mapEventToState(
    PlaylistPageEvent event,
  ) async* {
    if (event is LoadPlaylistPageEvent) {
      //LOAD CACHE AND REFRESH
      yield PlaylistPageLoadingState();
      try {
        //YIELD CACHE DATA
        final PlaylistPageData playlistPageData =
            await playlistDataRepository.getPlaylistData(
                event.playlistId, AppCacheStrategy.LOAD_CACHE_FIRST);
        yield PlaylistPageLoadedState(playlistPageData: playlistPageData);

        if (isFromCatch(playlistPageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final PlaylistPageData playlistPageData =
                await playlistDataRepository.getPlaylistData(
              event.playlistId,
              AppCacheStrategy.CACHE_LATER,
            );
            yield PlaylistPageLoadingState();
            yield PlaylistPageLoadedState(playlistPageData: playlistPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield PlaylistPageLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
