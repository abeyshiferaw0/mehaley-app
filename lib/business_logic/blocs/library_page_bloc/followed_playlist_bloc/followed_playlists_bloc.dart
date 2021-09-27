import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/library_page_following_data.dart';
import 'package:elf_play/data/models/library_data/followed_playlist.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'followed_playlists_event.dart';
part 'followed_playlists_state.dart';

class FollowedPlaylistsBloc
    extends Bloc<FollowedPlaylistEvent, FollowedPlaylistsState> {
  FollowedPlaylistsBloc({required this.libraryPageDataRepository})
      : super(FollowedPlaylistInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<FollowedPlaylistsState> mapEventToState(
    FollowedPlaylistEvent event,
  ) async* {
    if (event is LoadFollowedPlaylistsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield FollowedPlaylistsLoadingState();
      try {
        //YIELD CACHE DATA
        final FollowingItemsData followedItemsData =
            await libraryPageDataRepository.getFollowedItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppFollowedPageItemTypes.PLAYLISTS,
        );

        ///YIELD BASED ON PAGE
        yield FollowedPlaylistsLoadedState(
          followedPlaylists: followedItemsData.followedPlaylists!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(followedItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final FollowingItemsData followedPlaylistsData =
                await libraryPageDataRepository.getFollowedItems(
              AppCacheStrategy.CACHE_LATER,
              AppFollowedPageItemTypes.PLAYLISTS,
            );

            yield FollowedPlaylistsLoadingState();

            ///YIELD BASED ON PAGE
            yield FollowedPlaylistsLoadedState(
              followedPlaylists: followedPlaylistsData.followedPlaylists!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield FollowedPlaylistsLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshFollowedPlaylistsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadFollowedPlaylistsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
