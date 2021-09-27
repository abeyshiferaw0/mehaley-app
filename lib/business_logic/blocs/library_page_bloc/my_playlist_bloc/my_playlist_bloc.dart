import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/my_playlist_page_data.dart';
import 'package:elf_play/data/repositories/my_playlist_repository.dart';
import 'package:equatable/equatable.dart';

part 'my_playlist_event.dart';
part 'my_playlist_state.dart';

class MyPlaylistBloc extends Bloc<MyPlaylistEvent, MyPlaylistState> {
  MyPlaylistBloc({required this.myPlaylistRepository})
      : super(MyPlaylistInitial());

  final MyPLayListRepository myPlaylistRepository;

  @override
  Stream<MyPlaylistState> mapEventToState(
    MyPlaylistEvent event,
  ) async* {
    if (event is LoadAllMyPlaylistsEvent) {
      //LOAD CACHE AND REFRESH
      yield MyPlaylistLoadingState();
      try {
        //YIELD CACHE DATA
        final MyPlaylistPageData cachedMyPlaylistPageData =
            await myPlaylistRepository
                .getMyPlaylistData(AppCacheStrategy.LOAD_CACHE_FIRST);
        yield MyPlaylistPageDataLoaded(
            myPlaylistPageData: cachedMyPlaylistPageData);

        if (isFromCatch(cachedMyPlaylistPageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            if (event.isForAddSongPage) {
              yield MyPlaylistRefreshLoadingState();
            }
            final MyPlaylistPageData refreshedMyPlaylistPageData =
                await myPlaylistRepository
                    .getMyPlaylistData(AppCacheStrategy.CACHE_LATER);
            yield MyPlaylistLoadingState();
            yield MyPlaylistPageDataLoaded(
                myPlaylistPageData: refreshedMyPlaylistPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        if (error is DioError) {
          if (CancelToken.isCancel(error)) {}
        }
        yield MyPlaylistLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshMyPlaylistEvent) {
      print("myPlaylistRepositoryyyy called");
      myPlaylistRepository.cancelDio();
      this.add(
        LoadAllMyPlaylistsEvent(isForAddSongPage: event.isForAddSongPage),
      );
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
