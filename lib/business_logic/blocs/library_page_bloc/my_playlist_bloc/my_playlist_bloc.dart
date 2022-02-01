import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/my_playlist_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/repositories/my_playlist_repository.dart';

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

        ///CHECK IF IS FOR DELETED PLAYLIST AND REMOVE DELETED PLAYLIST
        if (event.isForUserPlaylistDeleted != null) {
          if (event.isForUserPlaylistDeleted!) {
            if (event.deletedPlaylist != null) {
              cachedMyPlaylistPageData.myPlaylists
                  .remove(event.deletedPlaylist);
            }
          }
        }

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
        try {
          //REFRESH CACHE_LATER AFTER CACHE ERROR
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
          yield MyPlaylistLoadingErrorState(error: error.toString());
        }
      }
    } else if (event is RefreshMyPlaylistEvent) {
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
