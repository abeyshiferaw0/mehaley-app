import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/user_playlist_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/user_playlist_repository.dart';
import 'package:meta/meta.dart';

part 'user_playlist_page_event.dart';
part 'user_playlist_page_state.dart';

class UserPlaylistPageBloc
    extends Bloc<UserPlaylistPageEvent, UserPlaylistPageState> {
  UserPlaylistPageBloc({required this.userPLayListRepository})
      : super(UserPlaylistPageInitial());

  final UserPLayListRepository userPLayListRepository;

  @override
  Stream<UserPlaylistPageState> mapEventToState(
    UserPlaylistPageEvent event,
  ) async* {
    if (event is LoadUserPlaylistPageEvent) {
      //LOAD CACHE AND REFRESH
      yield UserPlaylistPageLoadingState();
      try {
        //YIELD CACHE DATA
        final UserPlaylistPageData userPlaylistPageData =
            await userPLayListRepository.getUserPlaylistData(
                event.playlistId, AppCacheStrategy.LOAD_CACHE_FIRST);
        yield UserPlaylistPageLoadedState(
            userPlaylistPageData: userPlaylistPageData);

        if (isFromCatch(userPlaylistPageData.response!)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final UserPlaylistPageData userPlaylistPageData =
                await userPLayListRepository.getUserPlaylistData(
              event.playlistId,
              AppCacheStrategy.CACHE_LATER,
            );
            yield UserPlaylistPageLoadingState();
            yield UserPlaylistPageLoadedState(
                userPlaylistPageData: userPlaylistPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield UserPlaylistPageLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshUserPlaylistPageEvent) {
      ///REFRESH PLAYLIST PAGE
      yield UserPlaylistPageLoadingState();
      try {
        yield UserPlaylistPageLoadedState(
          userPlaylistPageData: UserPlaylistPageData(
            myPlaylist: event.myPlaylist,
            songs: event.songs,
            response: null,
          ),
        );
      } catch (error) {
        yield UserPlaylistPageLoadingErrorState(error: error.toString());
      }
    } else if (event is SongRemovedFromPlaylistEvent) {
      //LOAD CACHE AND REFRESH
      yield UserPlaylistPageLoadingState();
      try {
        //YIELD CACHE DATA
        final UserPlaylistPageData userPlaylistPageData =
            await userPLayListRepository.getUserPlaylistData(
                event.playlistId, AppCacheStrategy.LOAD_CACHE_FIRST);

        ///REMOVE THE REMOVED SONGS
        if (userPlaylistPageData.songs.contains(event.song)) {
          userPlaylistPageData.songs.remove(event.song);
        }

        yield UserPlaylistPageLoadedState(
            userPlaylistPageData: userPlaylistPageData);

        if (isFromCatch(userPlaylistPageData.response!)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final UserPlaylistPageData userPlaylistPageData =
                await userPLayListRepository.getUserPlaylistData(
              event.playlistId,
              AppCacheStrategy.CACHE_LATER,
            );
            yield UserPlaylistPageLoadingState();
            yield UserPlaylistPageLoadedState(
                userPlaylistPageData: userPlaylistPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield UserPlaylistPageLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
